# ElRaxy/tap

Homebrew formulae for my tools.

```sh
brew install elraxy/tap/sereno
```

## sereno

See what every coding-agent session on your machine is actually doing —
a single-file, stdlib-only terminal UI over the sessions of Claude Code
(and the history of Codex, Gemini and Antigravity).

Source, docs and issues: **[ElRaxy/sereno](https://github.com/ElRaxy/sereno)**.
Bug reports about `sereno` itself go there, not here; this repo only carries
the packaging.

Upgrades come with `brew upgrade`. The formula is bumped by `release.sh` in the
sereno repo, right after the release asset is published and verified, so the tap
never points at a version that was not checked.
