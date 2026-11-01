#!/usr/bin/env node
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const skillsDir = join(root, 'skills');
let failures = 0;

function fail(msg) {
  console.error(`FAIL: ${msg}`);
  failures++;
}

// --- SKILL.md checks ---
const skillDirs = readdirSync(skillsDir, { withFileTypes: true })
  .filter((d) => d.isDirectory())
  .map((d) => d.name);

const skillFiles = new Map();
for (const dir of skillDirs) {
  const files = existsSync(join(skillsDir, dir))
    ? readdirSync(join(skillsDir, dir))
    : [];
  skillFiles.set(dir, new Set(files));
}

for (const dir of skillDirs) {
  const skillPath = join(skillsDir, dir, 'SKILL.md');
  if (!existsSync(skillPath)) {
    fail(`${dir}: missing SKILL.md`);
    continue;
  }
  const content = readFileSync(skillPath, 'utf8');
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) {
    fail(`${dir}: SKILL.md has no YAML frontmatter`);
    continue;
  }
  const fm = match[1];
  if (fm.length > 1024) fail(`${dir}: frontmatter is ${fm.length} chars (>1024)`);

  const name = fm.match(/^name:\s*(.+)$/m)?.[1]?.trim();
  if (!name) fail(`${dir}: frontmatter missing 'name'`);
  else if (name !== dir) fail(`${dir}: name '${name}' != folder name`);
  else if (!/^[a-z0-9-]+$/.test(name)) fail(`${dir}: name '${name}' has invalid chars`);

  const desc = fm.match(/^description:\s*(.+)$/m)?.[1]?.trim();
  if (!desc) fail(`${dir}: frontmatter missing 'description'`);
  else if (!desc.startsWith('Use when')) fail(`${dir}: description does not start with "Use when"`);

  // backticked *.md references that point into the skill dirs must exist in
  // this dir or a sibling skill dir. Bare filenames resolve against the
  // skill dirs; refs under reports/, briefs/, metrics/ or the project-root
  // game-trend-profile.md are runtime outputs, not bundled files.
  const refs = [...content.matchAll(/`([^`]*?\.md)`/g)].map((m) => m[1]);
  for (const ref of refs) {
    const parts = ref.split('/');
    if (parts.length > 1 && !skillDirs.includes(parts[0])) continue;
    if (ref === 'game-trend-profile.md') continue;
    const base = parts.pop();
    if (skillFiles.get(dir).has(base)) continue;
    const sibling = skillDirs.find((d) => d !== dir && skillFiles.get(d).has(base));
    if (sibling) {
      console.log(`INFO: ${dir} references '${ref}' found in sibling skill '${sibling}'`);
    } else {
      fail(`${dir}: references '${ref}' but no skill dir contains '${base}'`);
    }
  }
}

// --- JSON manifest checks ---
const manifestPaths = [
  '.claude-plugin/plugin.json',
  '.claude-plugin/marketplace.json',
  '.codex-plugin/plugin.json',
  '.cursor-plugin/plugin.json',
  '.devin-plugin/plugin.json',
  '.antigravity-plugin/plugin.json',
  '.agents/plugins/marketplace.json',
  'gemini-extension.json',
];

const versions = new Map();
for (const rel of manifestPaths) {
  const p = join(root, rel);
  if (!existsSync(p)) {
    fail(`${rel}: missing`);
    continue;
  }
  try {
    const json = JSON.parse(readFileSync(p, 'utf8'));
    const v = json.version ?? json.plugins?.[0]?.version;
    if (v) versions.set(rel, v);
  } catch (e) {
    fail(`${rel}: invalid JSON (${e.message})`);
  }
}
// .agents marketplace must point at the public git repo
const agentsMkt = JSON.parse(readFileSync(join(root, '.agents/plugins/marketplace.json'), 'utf8'));
const agentsUrl = agentsMkt.plugins?.[0]?.source?.url;
if (agentsUrl !== 'https://github.com/malicaki/game-trend-skills.git') {
  fail(`.agents/plugins/marketplace.json: plugin source url is '${agentsUrl}', expected 'https://github.com/malicaki/game-trend-skills.git'`);
}

const uniqueVersions = new Set(versions.values());
if (uniqueVersions.size > 1) {
  fail(`version mismatch across manifests: ${[...versions.entries()].map(([k, v]) => `${k}=${v}`).join(', ')}`);
}

if (failures === 0) {
  console.log(`OK: ${skillDirs.length} skills, ${manifestPaths.length} manifests, version ${[...uniqueVersions][0] ?? 'n/a'}`);
  process.exit(0);
} else {
  console.error(`${failures} failure(s)`);
  process.exit(1);
}
