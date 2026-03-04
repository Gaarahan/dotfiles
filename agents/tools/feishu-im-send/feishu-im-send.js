#!/usr/bin/env node

/**
 * Feishu/Lark robot message sender (fsopen.bytedance.net)
 *
 * - Fetch `tenant_access_token` via `/open-apis/auth/v3/tenant_access_token/internal`
 * - Cache token with expireAt (seconds)
 * - Refresh on expiry, and retry once on 401/403
 *
 * Usage:
 *   feishu-im-send "hello"
 *   feishu-im-send --text "hello" --receive-id "ou_xxx"
 *   feishu-im-send --show-config
 *   feishu-im-send --configure
 *   feishu-im-send --configure --app-id "xxx" --app-secret "yyy" --receive-id "ou_xxx" --force
 *
 * Env:
 *   FEISHU_APP_ID / FEISHU_APP_SECRET
 *   FEISHU_RECEIVE_ID (optional default receive_id)
 *
 * Env file (optional):
 *   - Default: ~/.config/feishu-im-send/env
 *   - Override: --env-file <path> or FEISHU_IM_SEND_ENV_FILE
 */

const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const crypto = require('node:crypto');
const readline = require('node:readline');

const SEND_URL =
  'https://fsopen.bytedance.net/open-apis/im/v1/messages?receive_id_type=open_id';
const TOKEN_URL =
  'https://fsopen.bytedance.net/open-apis/auth/v3/tenant_access_token/internal';

// IMPORTANT: do not provide a hardcoded default receive_id in OSS.
// Always pass via `--receive-id` or set `FEISHU_RECEIVE_ID`.

const CACHE_PATH = path.join(
  os.homedir(),
  '.cache',
  'feishu-im-send',
  'tenant_access_token.json',
);

function die(msg, code = 1) {
  process.stderr.write(`${msg}\n`);
  process.exit(code);
}

function nowSeconds() {
  return Math.floor(Date.now() / 1000);
}

function ensureDir(p) {
  fs.mkdirSync(p, { recursive: true });
}

function readCache() {
  try {
    const raw = fs.readFileSync(CACHE_PATH, 'utf8');
    const json = JSON.parse(raw);
    if (!json || typeof json !== 'object') return null;
    if (typeof json.token !== 'string') return null;
    if (typeof json.expireAt !== 'number') return null;
    return json;
  } catch {
    return null;
  }
}

function writeCache(token, expireAt) {
  ensureDir(path.dirname(CACHE_PATH));
  // Token is sensitive; keep the cache file private.
  fs.writeFileSync(CACHE_PATH, JSON.stringify({ token, expireAt }, null, 2), {
    encoding: 'utf8',
    mode: 0o600,
  });
  try {
    fs.chmodSync(CACHE_PATH, 0o600);
  } catch {
    // ignore
  }
}

function clearCache() {
  try {
    fs.unlinkSync(CACHE_PATH);
  } catch {
    // ignore
  }
}

function getDefaultEnvFilePath() {
  const xdgConfigHome =
    process.env.XDG_CONFIG_HOME || path.join(os.homedir(), '.config');
  return path.join(xdgConfigHome, 'feishu-im-send', 'env');
}

function stripQuotes(s) {
  const t = s.trim();
  if (
    (t.startsWith('"') && t.endsWith('"')) ||
    (t.startsWith("'") && t.endsWith("'"))
  ) {
    return t.slice(1, -1);
  }
  return t;
}

function parseEnvLines(content) {
  const out = {};
  const lines = String(content || '').split(/\r?\n/);
  for (const line of lines) {
    const raw = line.trim();
    if (!raw || raw.startsWith('#')) continue;
    const l = raw.startsWith('export ') ? raw.slice('export '.length).trim() : raw;
    const idx = l.indexOf('=');
    if (idx <= 0) continue;
    const key = l.slice(0, idx).trim();
    const val = stripQuotes(l.slice(idx + 1));
    if (!key) continue;
    out[key] = val;
  }
  return out;
}

function loadEnvFile(envFilePath) {
  try {
    if (!envFilePath) return { loaded: false, path: '' };
    if (!fs.existsSync(envFilePath)) return { loaded: false, path: envFilePath };
    const raw = fs.readFileSync(envFilePath, 'utf8');
    const parsed = parseEnvLines(raw);
    // Only fill missing envs; real process.env wins.
    for (const [k, v] of Object.entries(parsed)) {
      if (!process.env[k] && typeof v === 'string') process.env[k] = v;
    }
    return { loaded: true, path: envFilePath };
  } catch {
    return { loaded: false, path: envFilePath };
  }
}

function getDefaultReceiveId() {
  return process.env.FEISHU_RECEIVE_ID || '';
}

function getAppCreds() {
  const appId = process.env.FEISHU_APP_ID || '';
  const appSecret = process.env.FEISHU_APP_SECRET || '';
  if (!appId || !appSecret) {
    die(
      '缺少应用凭证：请设置 FEISHU_APP_ID / FEISHU_APP_SECRET（或运行 feishu-im-send --configure）',
    );
  }
  return { appId, appSecret };
}

function maskSecret(s) {
  const v = String(s || '');
  if (!v) return '';
  if (v.length <= 8) return `${v.slice(0, 2)}***${v.slice(-2)}`;
  return `${v.slice(0, 4)}***${v.slice(-4)}`;
}

function prompt(question) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  return new Promise((resolve) => {
    rl.question(question, (ans) => {
      rl.close();
      resolve(ans);
    });
  });
}

async function configureEnv({ envFilePath, appId, appSecret, receiveId, force }) {
  const target = envFilePath || getDefaultEnvFilePath();
  ensureDir(path.dirname(target));

  const existing = fs.existsSync(target);
  if (existing && !force) {
    const ans = String(
      await prompt(`检测到已有配置：${target}\n是否覆盖（会备份为 .bak）？(y/N) `),
    ).trim();
    if (!['y', 'Y', 'yes', 'YES'].includes(ans)) {
      die('已取消', 0);
    }
    try {
      fs.copyFileSync(target, `${target}.bak`);
    } catch {
      // ignore backup errors
    }
  }

  const finalAppId =
    (typeof appId === 'string' && appId.trim()) ||
    String(await prompt('FEISHU_APP_ID: ')).trim();
  const finalAppSecret =
    (typeof appSecret === 'string' && appSecret.trim()) ||
    String(await prompt('FEISHU_APP_SECRET: ')).trim();
  const defaultReceiveId = getDefaultReceiveId();
  const finalReceiveId =
    (typeof receiveId === 'string' && receiveId.trim()) ||
    String(
      await prompt(
        `FEISHU_RECEIVE_ID (可选${defaultReceiveId ? `，默认 ${defaultReceiveId}` : ''}): `,
      ),
    ).trim();

  if (!finalAppId || !finalAppSecret) {
    die('缺少 FEISHU_APP_ID 或 FEISHU_APP_SECRET，已取消');
  }

  const lines = [
    '# feishu-im-send env file',
    '# format: KEY=VALUE',
    `FEISHU_APP_ID=${finalAppId}`,
    `FEISHU_APP_SECRET=${finalAppSecret}`,
  ];
  if (finalReceiveId) lines.push(`FEISHU_RECEIVE_ID=${finalReceiveId}`);
  lines.push('');

  fs.writeFileSync(target, lines.join('\n'), { encoding: 'utf8', mode: 0o600 });
  try {
    fs.chmodSync(target, 0o600);
  } catch {
    // ignore
  }
  process.stdout.write(`已写入：${target}\n`);
}

async function fetchJson(url, init) {
  const res = await fetch(url, init);
  const text = await res.text().catch(() => '');
  let json = null;
  if (text) {
    try {
      json = JSON.parse(text);
    } catch {
      json = null;
    }
  }
  return { res, text, json };
}

async function getTenantAccessToken() {
  const cached = readCache();
  const now = nowSeconds();
  if (cached && cached.expireAt - 60 > now) return cached.token;

  const { appId, appSecret } = getAppCreds();
  const { res, text, json } = await fetchJson(TOKEN_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      app_id: appId,
      app_secret: appSecret,
    }),
  });

  if (!res.ok) {
    die(
      `获取 tenant_access_token 失败：${res.status} ${res.statusText}${text ? ` - ${text}` : ''}`,
    );
  }
  if (!json || json.code !== 0 || !json.tenant_access_token) {
    die(
      `获取 tenant_access_token 业务失败：${json && typeof json.code === 'number' ? json.code : 'unknown'}${json && json.msg ? ` - ${json.msg}` : ''}`,
    );
  }

  const expireSeconds = typeof json.expire === 'number' ? json.expire : 0;
  const expireAt = now + expireSeconds;
  writeCache(json.tenant_access_token, expireAt);
  return json.tenant_access_token;
}

function parseArgs(argv) {
  const args = {
    action: 'send',
    text: '',
    receiveId: '',
    envFile: process.env.FEISHU_IM_SEND_ENV_FILE || '',
    configure: {
      appId: '',
      appSecret: '',
      receiveId: '',
      force: false,
    },
  };
  const rest = argv.slice(2);

  if (rest.includes('-h') || rest.includes('--help')) {
    die(
      [
        '用法：',
        '  feishu-im-send "消息内容"',
        '  feishu-im-send --text "消息内容" --receive-id "ou_xxx"',
        '  feishu-im-send --show-config',
        '  feishu-im-send --configure',
        '  feishu-im-send --configure --app-id "xxx" --app-secret "yyy" --receive-id "ou_xxx" --force',
        '',
        'env 文件（可选）：',
        `  默认：${getDefaultEnvFilePath()}`,
        '  覆盖：--env-file <path> 或 FEISHU_IM_SEND_ENV_FILE',
        '',
        '环境变量：',
        '  FEISHU_APP_ID / FEISHU_APP_SECRET',
        '  FEISHU_RECEIVE_ID（可选；发送消息时可作为默认值）',
      ].join('\n'),
      0,
    );
  }

  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (a === '--text' || a === '-t') {
      args.text = rest[++i] || '';
    } else if (a === '--receive-id' || a === '-r') {
      const v = rest[++i] || '';
      // reuse the same flag for both send/configure
      args.receiveId = v;
      args.configure.receiveId = v;
    } else if (a === '--env-file') {
      args.envFile = rest[++i] || '';
    } else if (a === '--show-config') {
      args.action = 'show-config';
    } else if (a === '--configure') {
      args.action = 'configure';
    } else if (a === '--app-id') {
      args.configure.appId = rest[++i] || '';
    } else if (a === '--app-secret') {
      args.configure.appSecret = rest[++i] || '';
    } else if (a === '--force') {
      args.configure.force = true;
    } else if (!a.startsWith('-') && !args.text) {
      // positional text
      args.text = a;
    } else {
      die(`未知参数：${a}，用 --help 查看用法`);
    }
  }

  // Load env file early so later defaults can see it.
  loadEnvFile(args.envFile || getDefaultEnvFilePath());

  if (!args.receiveId) args.receiveId = getDefaultReceiveId();

  if (args.action === 'send') {
    if (!args.text) die('缺少消息内容：传入 "消息内容" 或 --text');
    if (!args.receiveId)
      die('缺少 receive_id：传入 --receive-id 或设置 FEISHU_RECEIVE_ID');
  }
  return args;
}

async function sendOnce(token, receiveId, text) {
  const body = {
    content: JSON.stringify({ text }),
    msg_type: 'text',
    receive_id: receiveId,
    uuid: crypto.randomUUID(),
  };

  const { res, text: raw, json } = await fetchJson(SEND_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });

  return { res, raw, json };
}

async function main() {
  const args = parseArgs(process.argv);
  const { action, text, receiveId, envFile, configure } = args;

  if (action === 'configure') {
    await configureEnv({
      envFilePath: envFile || getDefaultEnvFilePath(),
      appId: configure.appId,
      appSecret: configure.appSecret,
      receiveId: configure.receiveId || receiveId,
      force: configure.force,
    });
    return;
  }

  if (action === 'show-config') {
    const appId = process.env.FEISHU_APP_ID || '';
    const appSecret = process.env.FEISHU_APP_SECRET || '';
    const rid = process.env.FEISHU_RECEIVE_ID || '';
    const envPath = envFile || getDefaultEnvFilePath();
    const exists = fs.existsSync(envPath);
    process.stdout.write(
      [
        `envFile: ${envPath}${exists ? ' (exists)' : ' (missing)'}`,
        `FEISHU_APP_ID: ${appId || '(empty)'}`,
        `FEISHU_APP_SECRET: ${appSecret ? maskSecret(appSecret) : '(empty)'}`,
        `FEISHU_RECEIVE_ID: ${rid || '(empty)'}`,
      ].join('\n') +
        '\n',
    );
    return;
  }

  let token = await getTenantAccessToken();

  let out = await sendOnce(token, receiveId, text);
  if (out.res.status === 401 || out.res.status === 403) {
    // token expired/invalid: clear and retry once
    clearCache();
    token = await getTenantAccessToken();
    out = await sendOnce(token, receiveId, text);
  }

  if (!out.res.ok) {
    die(
      `发送消息失败：${out.res.status} ${out.res.statusText}${out.raw ? ` - ${out.raw}` : ''}`,
    );
  }
  // Print response for debugging / piping
  process.stdout.write(
    `${out.raw && out.raw.trim() ? out.raw.trim() : JSON.stringify(out.json || {}, null, 2)}\n`,
  );
}

main().catch((e) => {
  die(e && e.stack ? e.stack : String(e));
});
