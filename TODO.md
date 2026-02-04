# TODO - Future Plans

This file tracks planned improvements and features for dbtools. Pick any task and start working on it!

## High Priority

- [ ] **Add demo GIF to README** - Use `asciinema` or `terminalizer` to record a demo showing dump/restore in action
- [ ] **Add GitHub topics** - Add tags: `mysql`, `database`, `backup`, `restore`, `bash`, `cli`, `devops`, `database-tools`
- [ ] **Create GitHub release v1.0.0** - Tag the release with changelog

## Distribution & Packaging

- [ ] **Create Homebrew formula** - Allow `brew install the-perfect-developer/tap/dbtools`
- [ ] **Submit to awesome-bash** - https://github.com/awesome-lists/awesome-bash
- [ ] **Submit to awesome-mysql** - https://github.com/shlomi-noach/awesome-mysql
- [ ] **Create AUR package** - For Arch Linux users
- [ ] **Create DEB package** - For Debian/Ubuntu users

## Documentation & Community

- [ ] **Add CONTRIBUTING.md** - Guidelines for contributors
- [ ] **Add CODE_OF_CONDUCT.md** - Community standards
- [ ] **Write blog post** - "How I built a resumable MySQL backup tool in Bash"
- [ ] **Create social preview image** - 1280x640px banner for GitHub
- [ ] **Add "Why dbtools?" section to README** - Explain the problem it solves

## Technical Improvements

- [ ] **Add GitHub Actions CI** - Lint with shellcheck, syntax validation
- [ ] **Add basic tests** - Test argument parsing, help output
- [ ] **Add --dry-run flag to dump** - Show what would be dumped without executing
- [ ] **Add --verbose flag** - More detailed output during operations
- [ ] **Add --quiet flag** - Suppress non-essential output
- [ ] **Support for .dbtools.conf** - Config file for default options
- [ ] **Add color output toggle** - `--no-color` flag for CI/logs

## New Commands

- [ ] **tables** - List all tables in a database with row counts
- [ ] **schema** - Dump only schema (no data)
- [ ] **diff** - Compare schemas between two databases
- [ ] **clone** - Clone a database to another name/server
- [ ] **truncate** - Truncate all tables (with confirmation)
- [ ] **size** - Show database/table sizes

## Promotion

- [ ] **Post on Reddit** - r/bash, r/commandline, r/mysql, r/devops, r/selfhosted
- [ ] **Submit to Hacker News** - "Show HN: dbtools - MySQL dump/restore with resume support"
- [ ] **Post on Dev.to** - Tutorial article
- [ ] **Share on Twitter/X** - With #mysql #bash #devops hashtags
- [ ] **Answer Stack Overflow questions** - Mention dbtools where relevant

---

## Completed

- [x] Create main dbtools.sh entry point with auto-discovery
- [x] Add dump command with --limit and --tables options
- [x] Add restore command with progress display
- [x] Add update command for self-updating
- [x] Add install.sh for local installation
- [x] Add get.sh for curl one-liner installation
- [x] Add ASCII banner with author details
- [x] Categorize commands (Database, System)
- [x] Push to GitHub
