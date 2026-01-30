#!/usr/bin/env -S node --experimental-strip-types

/**
 * Cherry-pick commits onto a new branch using a temporary worktree.
 *
 * This tool creates a branch from master (or specified base), cherry-picks
 * the given commits, and pushes to GitHub - all without affecting your
 * current working directory.
 *
 * Requires Node.js 22.6+ with --experimental-strip-types support.
 *
 * Usage:
 *   git-cherry-pick-branch -b my-feature abc123 def456 ghi789
 *   git-cherry-pick-branch -b hotfix/issue-123 --base release/prod abc123
 *   git-cherry-pick-branch -b my-branch --dry-run abc123 def456
 *   git-cherry-pick-branch -b my-branch --skip-empty abc123
 */

import { spawnSync } from 'child_process';
import { existsSync, mkdtempSync, rmSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { parseArgs } from 'util';

interface Options {
  branch: string;
  base: string;
  push: boolean;
  dryRun: boolean;
  verbose: boolean;
  skipEmpty: boolean;
}

function verboseLog(message: string, options: Options): void {
  if (options.verbose) {
    console.log(`[verbose] ${message}`);
  }
}

function execGit(
  args: string[],
  options: Options,
  execOptions: { cwd?: string } = {}
): string {
  const cmd = `git ${args.join(' ')}`;
  verboseLog(`Executing: ${cmd}`, options);

  if (options.dryRun && isWriteOperation(args)) {
    console.log(`[dry-run] Would execute: ${cmd}`);
    return '';
  }

  // When running in a custom cwd (like a new worktree), we need to unset
  // GIT_DIR and GIT_WORK_TREE to avoid conflicts with the parent repo's
  // environment. This is especially important when the script is run via
  // a git alias, which sets these variables.
  const env = execOptions.cwd
    ? { ...process.env, GIT_DIR: undefined, GIT_WORK_TREE: undefined }
    : process.env;

  const result = spawnSync('git', args, {
    cwd: execOptions.cwd,
    env,
    stdio: 'pipe',
    encoding: 'utf-8',
  });

  if (result.status !== 0) {
    const errorMsg = result.stderr || result.stdout || 'Unknown error';
    throw new Error(`Git command failed: ${cmd}\n${errorMsg}`);
  }

  return result.stdout?.trim() || '';
}

function isWriteOperation(args: string[]): boolean {
  const writeCommands = [
    'checkout',
    'cherry-pick',
    'push',
    'worktree',
    'branch',
  ];
  return writeCommands.includes(args[0]);
}

function validateSha(sha: string): boolean {
  // Git SHA can be short (7+) or full (40 chars)
  return /^[a-f0-9]{7,40}$/i.test(sha);
}

function getRepoRoot(options: Options): string {
  return execGit(['rev-parse', '--show-toplevel'], {
    ...options,
    dryRun: false,
  });
}

function branchExists(branch: string, options: Options): boolean {
  try {
    execGit(['rev-parse', '--verify', `refs/heads/${branch}`], {
      ...options,
      dryRun: false,
    });
    return true;
  } catch {
    return false;
  }
}

function remoteBranchExists(branch: string, options: Options): boolean {
  try {
    execGit(['rev-parse', '--verify', `refs/remotes/origin/${branch}`], {
      ...options,
      dryRun: false,
    });
    return true;
  } catch {
    return false;
  }
}

function resolveCommit(sha: string, options: Options): string {
  try {
    return execGit(['rev-parse', '--verify', sha], {
      ...options,
      dryRun: false,
    });
  } catch {
    throw new Error(`Could not resolve commit: ${sha}`);
  }
}

function getCommitInfo(sha: string, options: Options): string {
  return execGit(['log', '--oneline', '-1', sha], {
    ...options,
    dryRun: false,
  });
}

async function cherryPickBranch(
  shas: string[],
  options: Options
): Promise<void> {
  getRepoRoot(options); // Validate we're in a git repo
  let worktreePath: string | null = null;

  try {
    // Validate inputs
    if (!options.branch) {
      throw new Error('Branch name is required (--branch or -b)');
    }

    if (shas.length === 0) {
      throw new Error('At least one commit SHA is required');
    }

    // Validate all SHAs
    for (const sha of shas) {
      if (!validateSha(sha)) {
        throw new Error(`Invalid SHA format: ${sha}`);
      }
    }

    // Check if branch already exists
    if (branchExists(options.branch, options)) {
      throw new Error(
        `Local branch '${options.branch}' already exists. Delete it first or use a different name.`
      );
    }

    if (remoteBranchExists(options.branch, options)) {
      throw new Error(
        `Remote branch 'origin/${options.branch}' already exists. Delete it first or use a different name.`
      );
    }

    // Fetch latest from origin
    console.log('📥 Fetching latest from origin...');
    execGit(['fetch', 'origin'], options);

    // Resolve base branch
    const baseBranch = options.base.startsWith('origin/')
      ? options.base
      : `origin/${options.base}`;

    console.log(`📌 Base branch: ${baseBranch}`);

    // Verify base branch exists
    try {
      execGit(['rev-parse', '--verify', baseBranch], {
        ...options,
        dryRun: false,
      });
    } catch {
      throw new Error(`Base branch '${baseBranch}' does not exist`);
    }

    // Resolve and display commits to cherry-pick
    console.log('\n🍒 Commits to cherry-pick:');
    const resolvedShas: string[] = [];
    for (const sha of shas) {
      const resolved = resolveCommit(sha, options);
      const info = getCommitInfo(resolved, options);
      console.log(`   ${info}`);
      resolvedShas.push(resolved);
    }

    // Create temporary worktree
    worktreePath = mkdtempSync(join(tmpdir(), 'git-cherry-pick-'));
    console.log(`\n📁 Creating temporary worktree at ${worktreePath}...`);

    if (!options.dryRun) {
      execGit(
        ['worktree', 'add', '-b', options.branch, worktreePath, baseBranch],
        options
      );
    } else {
      console.log(
        `[dry-run] Would create worktree with branch '${options.branch}' from '${baseBranch}'`
      );
    }

    // Cherry-pick each commit
    console.log('\n🍒 Cherry-picking commits...');
    let skippedCount = 0;
    for (const sha of resolvedShas) {
      const info = getCommitInfo(sha, options);
      console.log(`   Picking: ${info}`);

      if (!options.dryRun) {
        try {
          execGit(['cherry-pick', sha], options, { cwd: worktreePath });
        } catch (error) {
          const errorMsg =
            error instanceof Error ? error.message : String(error);

          // Check if cherry-pick resulted in empty commit (already applied)
          if (errorMsg.includes('cherry-pick is now empty')) {
            if (options.skipEmpty) {
              console.log(`   ⏭️  Skipping (already in ${options.base})`);
              execGit(['cherry-pick', '--skip'], options, {
                cwd: worktreePath,
              });
              skippedCount++;
              continue;
            } else {
              throw new Error(
                `Cherry-pick of ${sha} is empty (changes already in ${options.base}).\n` +
                  `Use --skip-empty to automatically skip such commits.`
              );
            }
          }

          // Check for conflicts
          const status = execGit(['status', '--porcelain'], options, {
            cwd: worktreePath,
          });
          if (status.includes('UU') || status.includes('AA')) {
            throw new Error(
              `Cherry-pick conflict on ${sha}. Resolve manually:\n` +
                `  cd ${worktreePath}\n` +
                `  git status\n` +
                `  # resolve conflicts\n` +
                `  git cherry-pick --continue`
            );
          }
          throw error;
        }
      }
    }

    if (skippedCount > 0) {
      console.log(
        `✅ Cherry-pick complete (${skippedCount} commit(s) skipped - already in base)`
      );
    } else {
      console.log('✅ All commits cherry-picked successfully!');
    }

    // Push to origin
    if (options.push) {
      console.log(`\n📤 Pushing branch '${options.branch}' to origin...`);
      if (!options.dryRun) {
        execGit(['push', '-u', 'origin', options.branch], options, {
          cwd: worktreePath,
        });
      }
      console.log('✅ Branch pushed successfully!');

      // Print PR creation URL
      const repoUrl = execGit(['remote', 'get-url', 'origin'], {
        ...options,
        dryRun: false,
      });
      const prUrl = repoUrl
        .replace(/\.git$/, '')
        .replace('git@github.com:', 'https://github.com/')
        .replace(/\n/g, '');
      console.log(
        `\n🔗 Create a PR: ${prUrl}/compare/${options.base}...${options.branch}?expand=1`
      );
    } else {
      console.log(
        `\n⏸️  Branch created but not pushed. Run with --push to push to origin.`
      );
    }
  } finally {
    // Clean up worktree
    if (worktreePath && existsSync(worktreePath)) {
      console.log('\n🧹 Cleaning up temporary worktree...');
      if (!options.dryRun) {
        try {
          execGit(['worktree', 'remove', '--force', worktreePath], options);
        } catch {
          // Fallback: manual cleanup
          rmSync(worktreePath, { recursive: true, force: true });
          execGit(['worktree', 'prune'], options);
        }
      }
    }
  }
}

const HELP = `
cherry-pick-branch - Create a branch from master with cherry-picked commits

Usage: git-cherry-pick-branch [options] <sha...>

Arguments:
  sha...                    Commit SHAs to cherry-pick (in order)

Options:
  -b, --branch <name>       Name of the new branch to create (required)
  --base <branch>           Base branch to create from (default: master)
  --push                    Push the branch to origin after creating (default)
  --no-push                 Do not push the branch to origin
  --dry-run                 Show what would be done without making changes
  --skip-empty              Skip commits that are already in the base branch
  -v, --verbose             Show verbose output
  -h, --help                Show this help message
  --version                 Show version number

Examples:
  git-cherry-pick-branch -b hotfix/issue-123 abc123 def456
  git-cherry-pick-branch -b hotfix/prod-fix --base release/prod abc123
  git-cherry-pick-branch -b my-branch --dry-run abc123 def456
  git-cherry-pick-branch -b my-branch --skip-empty --no-push abc123
`;

const { values, positionals } = parseArgs({
  args: process.argv.slice(2),
  options: {
    branch: { type: 'string', short: 'b' },
    base: { type: 'string', default: 'master' },
    push: { type: 'boolean', default: true },
    'no-push': { type: 'boolean' },
    'dry-run': { type: 'boolean', default: false },
    'skip-empty': { type: 'boolean', default: false },
    verbose: { type: 'boolean', short: 'v', default: false },
    help: { type: 'boolean', short: 'h' },
    version: { type: 'boolean' },
  },
  allowPositionals: true,
});

if (values.help) {
  console.log(HELP);
  process.exit(0);
}

if (values.version) {
  console.log('1.0.0');
  process.exit(0);
}

if (!values.branch) {
  console.error('Error: Branch name is required (--branch or -b)');
  console.error('Run with --help for usage information.');
  process.exit(1);
}

if (positionals.length === 0) {
  console.error('Error: At least one commit SHA is required');
  console.error('Run with --help for usage information.');
  process.exit(1);
}

const options: Options = {
  branch: values.branch,
  base: values.base ?? 'master',
  push: values['no-push'] ? false : values.push ?? true,
  dryRun: values['dry-run'] ?? false,
  verbose: values.verbose ?? false,
  skipEmpty: values['skip-empty'] ?? false,
};

cherryPickBranch(positionals, options).catch((error) => {
  console.error('\n❌ Error:', error instanceof Error ? error.message : error);
  process.exit(1);
});
