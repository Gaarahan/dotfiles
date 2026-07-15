# Inline Comment Collaboration Protocol

Use this protocol when the user answers or reviews a Lark clarification or technical document through inline comments.

## Invariants

- Treat every comment quote as a live document anchor. Preserve the quoted text and surrounding block unless the requested edit explicitly changes that text.
- Make narrow in-place edits. Do not broadly replace a section, renumber headings, reorder anchored content, resolve comments, or delete comments.
- A handled comment receives a reply prefixed with `「ByAgent」`. The user owns comment resolution.
- A successful write response is not proof of completion. The re-fetched document and comment relations are the source of truth.

## Procedure

1. Fetch the document with block identifiers and fetch comments with their relation metadata.
2. Classify comments:
   - pending: live anchor and no existing `「ByAgent」` reply;
   - handled: an existing `「ByAgent」` reply;
   - orphaned: the relation or quoted anchor no longer maps to document content.
3. Map each pending comment to its exact block and read enough surrounding content to understand the request.
4. If a comment requests an ambiguous structural rewrite or changes a confirmed contract, ask the user to align first. Otherwise edit the smallest safe range with block insertion, block replacement, or precise string replacement.
5. Re-fetch the document and comments. Verify the new revision, intended text, and survival of every still-live anchor.
6. Reply to each successfully handled comment with `「ByAgent」` followed by the concise disposition or remaining question.
7. Re-fetch once more to verify the reply and classify the resulting conclusions as confirmed, provisional, or unresolved in the task-local stage summary.

Use the raw comment-list response when a real `comment_id` is required. Inline comments can split a paragraph into multiple text runs, so select the edit method from the fetched block structure rather than assuming plain-text replacement will match.
