#!/usr/bin/env node
// Build per-skill zips for ChatGPT web Skills upload (Skills are standalone,
// so referenced sibling files are copied into each dependent skill's folder).
import { execFileSync } from 'node:child_process';
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const skillsDir = join(root, 'skills');
const distDir = join(root, 'dist');

// sibling files copied into each dependent skill's folder root
const COPIES = {
  'scanning-game-trends': ['using-game-trend-skills/sources.md', 'using-game-trend-skills/metrics-glossary.md'],
  'tracking-game-metrics': ['using-game-trend-skills/sources.md', 'using-game-trend-skills/metrics-glossary.md'],
  'launching-on-zero-budget': ['using-game-trend-skills/sources.md', 'using-game-trend-skills/metrics-glossary.md'],
  'brainstorming-game-ideas': ['evaluating-game-ideas/scoring-rubric.md'],
};

const skills = readdirSync(skillsDir, { withFileTypes: true })
  .filter((d) => d.isDirectory())
  .map((d) => d.name)
  .sort();

rmSync(distDir, { recursive: true, force: true });
mkdirSync(distDir, { recursive: true });

function zipDir(srcDir, zipPath) {
  // srcDir contains a single top-level folder; zip it so the archive has that folder at root
  if (process.platform === 'win32') {
    execFileSync('powershell', [
      '-NoProfile', '-Command',
      `Compress-Archive -Path '${join(srcDir, '*')}' -DestinationPath '${zipPath}' -Force`,
    ], { stdio: 'inherit' });
  } else {
    execFileSync('zip', ['-r', zipPath, '.'], { cwd: srcDir, stdio: 'inherit' });
  }
}

const stage = mkdtempSync(join(tmpdir(), 'gts-'));
try {
  const allDir = join(stage, 'all');
  for (const skill of skills) {
    const oneDir = join(stage, `one-${skill}`, skill);
    cpSync(join(skillsDir, skill), oneDir, { recursive: true });
    for (const ref of COPIES[skill] ?? []) {
      const src = join(skillsDir, ref);
      if (!existsSync(src)) throw new Error(`missing sibling file: ${ref}`);
      cpSync(src, join(oneDir, ref.split('/').pop()));
    }
    zipDir(join(stage, `one-${skill}`), join(distDir, `${skill}.zip`));

    cpSync(join(skillsDir, skill), join(allDir, skill), { recursive: true });
  }
  zipDir(allDir, join(distDir, 'game-trend-skills-all.zip'));
} finally {
  rmSync(stage, { recursive: true, force: true });
}

console.log(`wrote ${skills.length + 1} zips to ${distDir}`);
for (const f of readdirSync(distDir)) console.log(`  dist/${f}`);
