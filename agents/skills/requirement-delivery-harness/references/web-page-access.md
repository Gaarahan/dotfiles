# Web page access protocol

Use this protocol only when a supplied webpage must be rendered or interacted with. Prefer a purpose-built API, connector, or CLI for semantic document content when one is available.

## Runtime contract

- Use the official Microsoft Playwright MCP package, exposed through registered `browser_*` tools.
- Run Chrome headlessly by default. Use a persistent Chromium user-data directory only when the page requires an existing authenticated session.
- Use the project-configured, pinned MCP version for repeatability; do not silently switch to an unpinned latest version during a run.
- Preflight the registered tools before investigation. At minimum, navigation and page snapshot capabilities must be available.
- Do not fall back to the in-app browser, a Chrome extension, Computer Use, `agent-browser`, or a shell-launched browser when the Playwright MCP contract cannot be satisfied.

A typical MCP argument shape is:

```text
["-y", "@playwright/mcp@<pinned-version>", "--browser", "chrome", "--headless", "--user-data-dir", "<profile-dir>"]
```

Treat the profile path as runtime configuration. Never place a real profile path, cookies, storage state, tokens, or credentials in the Harness or task artifacts.

## Investigation procedure

1. Record why rendered browser access is required and which questions it must answer.
2. Navigate to the exact supplied URL and verify page identity from the top-level snapshot, final URL, and title before using any visual evidence.
3. Inspect only the relevant viewport, element, state, or interaction. Avoid full DOM dumps, broad accessibility-tree exports, and unrelated navigation.
4. Save required screenshots, snapshots, final URL, timestamp, and concise observations under the task-local `.workflow-memory` directory. Do not persist authentication material.
5. Close temporary pages after evidence capture.

## Blocking behavior

- If Playwright MCP tools are unavailable, report `browser_tool_unavailable` and the required setup. Do not improvise another browser backend.
- If the headless profile is unauthenticated or lacks permission, report the authentication or permission blocker. Do not switch to headed mode without explicit user approval.
- If page identity cannot be confirmed, do not treat the rendered content as requirement evidence.
