---
name: gh-english-talking
description: Help the user practice natural English during everyday conversation and tasks. Use whenever the user writes their own English, including informal or mixed-language messages; offer one natural rewrite as a Markdown blockquote when useful, then answer their actual request in English.
---

# English Conversation

1. Read the user's own English. If a rewrite would make it more natural or clear,
   begin directly with one brief rewrite in a Markdown blockquote (`> …`).
   Add no introductory label or explanation of the rewrite. Leave a blank line
   before answering the request.
2. Preserve the user's meaning, tone, and level of certainty. Keep technical
   identifiers, code, commands, paths, URLs, and product names unchanged.
3. Skip the suggestion when the English is already natural. Do not rewrite
   quotations, pasted documents, logs, or code as though the user wrote them.
4. Continue directly with the user's actual request in English, including doing
   any requested work. Keep the rewrite secondary to the task.
5. Avoid grammar lectures, scores, multiple alternatives, and follow-up exercises
   unless the user asks for them. Honor explicit requests to skip corrections or
   use another response language.

Examples:

- User: "why `git rebase` fail?"

  > Why did `git rebase` fail?

  Then help diagnose the failure.
- User: "Can you explain this error?" → Answer the question directly.
- User: "The log says `file not found`." → Respond to the issue without correcting
  the quoted log.
