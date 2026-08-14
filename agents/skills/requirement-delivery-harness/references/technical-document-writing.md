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

## Permission-solution review

For permission-sensitive frontend solutions, complete these checks before publication:

1. Separate new development from verification-only behavior and shared-module ownership. Do not count an existing compatible enforcement path as new implementation work.
2. Normalize the permission contract into the smallest set of user-visible business states. If a shared entity layer removes inaccessible entities before business rendering, record that boundary instead of inventing an unreachable business state.
3. When a new permission source feeds an existing UI state machine, document the current source, normalized state-machine inputs, unchanged transitions, and initialization signal. Treat the change as an input-adapter migration unless the transitions themselves change.
4. Inspect business branches and observability consumers independently. Tracking categories may preserve finer distinctions, but tracking-only data must not drive authorization or UI state.
5. Verify initialization, missing-data, and permission-change behavior from the real store and subscription path. Preserve an explicit resolved signal when an unresolved result differs from a confirmed denial.
6. Separate frontend capability presentation from execution authorization. For a user-facing surface that dispatches several operation families, list each operation, its enforcement owner, and its server-side denial boundary.
7. When a coarse permission gate is temporarily reused for a finer-grained requirement, state the invariant that makes them equivalent, the condition that invalidates that equivalence, and the follow-up enforcement work then required.
8. Lock the permission hierarchy and compatibility assumptions with acceptance cases. In particular, prevent contradictory states and ensure an absent or unresolved new signal cannot widen access.

## Publication verification

1. Create or update the Lark document using document XML.
2. Read the published document back.
3. Verify section order, tables, lists, diagrams, links, and all filled placeholders.
4. Check that confirmed conclusions are stated directly and unresolved items are not disguised as defaults.
5. Verify that every behavior change has a migration/default policy and at least one compatibility test.
6. Record the document URL and revision evidence in the stage summary before setting the stage to `delivery_ready`.
