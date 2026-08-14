# Frontend Technical Document Protocol

Use this protocol once the requirement-to-frontend-solution stage has enough confirmed information to produce a reviewable solution.

## Evidence before writing

1. Confirm the primary PRD, references, design artifacts, and repositories used by the solution.
2. Read repository instructions and the relevant knowledge-base material.
3. Locate existing implementations, permission contracts, data flow, feature gates, tests, and cross-repository dependencies.
4. Establish the shipped behavior baseline from product documentation and code. Do not treat the new PRD as evidence of current behavior.
5. Ensure every delivery-blocking question is resolved. List non-blocking unknowns explicitly under risks and unconfirmed items.

## Document construction

- Start with the conclusion, scope, and central design decision.
- For cross-team reviews, place a compact glossary before the numbered body when the design depends on product names, overloaded entity terms, generated artifacts, identifiers, or internal service abbreviations. Define the canonical meaning of ambiguous words, distinguish entity identity from generated content, and include only terms used later in the document.
- Describe the final system state. Exclude negotiation history and editing traces.
- Organize responsibilities by role or module; define internal concepts on first use.
- Give permission-sensitive requirements an operation-by-role matrix.
- For permission or contract changes, include a current-state versus target-state matrix. Cover existing entities, missing configuration, loading and failure fallbacks, feature enable/disable transitions, published or external access, rollback, and server-side enforcement.
- State the compatibility invariant explicitly: an absent or unresolved new permission signal must never silently widen access beyond the shipped baseline.
- Connect every proposed change to concrete modules, interfaces, state ownership, and test coverage.
- Use diagrams only when they materially clarify architecture, branching, or temporal behavior.
- Use the stable numbering and section order from `assets/frontend-solution-document.xml`.

## Publication verification

1. Create or update the Lark document using document XML.
2. Read the published document back.
3. Verify section order, tables, lists, diagrams, links, and all filled placeholders.
4. Check that confirmed conclusions are stated directly and unresolved items are not disguised as defaults.
5. Verify that every behavior change has a migration/default policy and at least one compatibility test.
6. Record the document URL and revision evidence in the stage summary before setting the stage to `delivery_ready`.
