# License / Attribution Notice

This standalone skill is an original adaptation inspired by the Common Ground command in Jeff Allan's `claude-skills` project.

Upstream project:
https://github.com/Jeffallan/claude-skills

The upstream project is distributed under the MIT License. This adaptation does not require or bundle the upstream project's other skills.

Core concepts retained from the upstream Common Ground design include:

- provenance types for assumptions;
- confidence tiers;
- persistent human-readable and machine-readable ground state;
- list/check/graph operating modes;
- Mermaid reasoning visualization.

This adaptation adds/changes behavior including a standalone `SKILL.md`, explicit decision provenance, historical-vs-reconstructed alternative labeling, dependency views, mind-map output, safer validation timestamps, and a stricter distinction between auditable reasoning structure and private chain-of-thought.
