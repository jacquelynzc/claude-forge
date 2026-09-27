# Assumption Classification

Common Ground tracks two independent properties:

1. **Provenance type** – how the premise entered the reasoning.
2. **Confidence tier** – how strongly it should be relied on now.

Keeping them separate prevents “the user once mentioned this” from turning into “this is permanently true.”

## Provenance types

### `stated`

The user explicitly supplied the premise, requirement, preference, correction, or decision.

Evidence should point to the user statement or a durable project instruction that clearly represents user intent.

Examples:

- “Use vanilla JS, not React.”
- “Do not expose this field publicly.”
- “The preview must take under five minutes.”

A stated premise is not automatically permanent. Newer user statements can supersede it.

### `inferred`

The premise is derived from observable project evidence.

Typical evidence:

- package/config files;
- repeated code patterns;
- directory structure;
- tests;
- scripts;
- schemas;
- git history.

Examples:

- A `tsconfig.json` and `.ts` source files imply TypeScript is in use.
- Every route using the same middleware suggests that middleware is the current auth boundary.

Inference strength depends on coverage and whether counterexamples exist.

### `assumed`

Claude introduced the premise as a default, convention, best practice, or pragmatic choice without direct evidence that this project requires it.

Examples:

- Assuming 80% test coverage is required.
- Choosing REST because no API style was specified.
- Assuming mobile-first behavior without a product requirement.

These deserve special scrutiny because they are the easiest way model defaults become accidental requirements.

### `uncertain`

The premise is genuinely unresolved, ambiguous, conflicting, or unsupported.

Examples:

- Two documents specify different launch dates.
- It is unclear whether a feature must work offline.
- Code supports two flows and there is no evidence which one is canonical.

Do not disguise uncertainty as an inference.

## Type immutability

Once an item is recorded, preserve its original type as provenance. If later evidence changes what is believed, update the tier, evidence, status, or archive/supersede the item rather than rewriting how it originally entered the reasoning.

If a premise is replaced by a genuinely new premise, create a new ID and link the old one as superseded.

## Confidence tiers

### `ESTABLISHED`

Strong enough to act on as a premise without repeatedly asking.

Good reasons:

- explicit current user validation;
- direct authoritative configuration;
- multiple strong corroborating sources;
- objective fact directly observed in the repository.

Do not promote subjective intent merely because code happens to implement it today.

### `WORKING`

Reasonable and useful, but should be revisited if contradictory evidence appears.

Good reasons:

- clear but non-authoritative code pattern;
- plausible inference from a single reliable source;
- informal user confirmation;
- low-impact default that is safe to reverse.

### `OPEN`

Do not make consequential decisions from this premise without resolving it.

Use when:

- evidence conflicts;
- there is no evidence;
- the choice depends on user/business intent;
- the assumption has high downstream impact and weak support;
- a previous premise has become stale.

## Impact adjustment

Confidence is not the same as risk. A medium-confidence assumption about naming can remain WORKING. A medium-confidence assumption about security boundaries, destructive migration behavior, money movement, privacy, public publishing, or irreversible architecture should usually be surfaced as OPEN until confirmed.

## Validation outcomes

During `--check`, use these states:

| Outcome | Meaning | Typical action |
|---|---|---|
| still supported | Evidence remains consistent | Keep tier; update validation evidence/date |
| weakened | Some support disappeared or exceptions emerged | Consider demotion |
| contradicted | Current evidence conflicts with premise | Demote or supersede/archive |
| cannot verify | Required evidence is unavailable | Do not pretend it was validated |
| superseded | A newer decision replaced it | Archive old item and link replacement |

## Useful extraction categories

Do not force every project into these, but they are good search lenses:

- Goal / success condition
- Scope / exclusions
- Product behavior
- Architecture / stack
- Data / persistence
- Security / privacy
- Integration contracts
- Design / UX
- Coding conventions
- Testing / quality
- Deployment / operations
- Business constraints
- User preferences
- Timeline / sequencing
- Known unknowns

## Quality test

Track a premise only if at least one is true:

- changing it would change implementation;
- it explains an important existing decision;
- it could cause expensive rework if wrong;
- it is likely to be forgotten across sessions;
- it resolves a recurring ambiguity;
- it is an unresolved dependency for future work.

Otherwise leave it out.
