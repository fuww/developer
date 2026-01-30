# developer.fashionunited.com

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ffuww%2Fdeveloper.fashionunited.com.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Ffuww%2Fdeveloper.fashionunited.com?ref=badge_shield)

FashionUnited Developer Portal, built with [Astro](https://astro.build/) and the excellent [Astro Starlight template](https://astro.build/themes/details/starlight/)

## Run

```bash
nix develop
npm install
npm run dev
```

## Run devenv

```bash
nix develop
npm run dev # works without installing node, npm, pnpm globally. Nix packaga manager is used.
```

## Install Nix package manager on MacOS

Install Nix with the Nix installer from [Determinate Systems](https://docs.determinate.systems/getting-started/organizations).

## Docker image

```bash
gcloud auth configure-docker europe-west1-docker.pkg.dev

Terminal window
# build your container
docker build -t developers-fashionunited-com .

docker tag developers-fashionunited-com europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest

# Push your image to a registry
docker push europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest

# One-liner:
docker build -t europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest . && docker push europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest
```

## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ffuww%2Fdeveloper.fashionunited.com.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Ffuww%2Fdeveloper.fashionunited.com?ref=badge_large)

## Ralph Wiggum Loop

```bash
while :; do cat prompt.md | claude --dangerously-skip-permissions;done
```

This project includes `loop.sh`, an implementation of the [Ralph Wiggum technique](https://ghuntley.com/ralph/) by [Geoffrey Huntley](https://github.com/ghuntley/how-to-ralph-wiggum) — a bash loop that runs Claude Code autonomously against a prompt file until all work is done.

### How it works

The loop picks up ready tasks from [beads](https://github.com/steveyegge/beads) issue tracking, feeds them to Claude via a prompt file (`PROMPT_build.md` or `PROMPT_plan.md`), and optionally runs a review phase after each iteration. Session state, logs, and metrics are stored in `.ralph/` (gitignored).

### Quick start

```sh
# Build mode (unlimited iterations, picks up ready beads tasks)
./loop.sh

# Plan mode (3 iterations by default)
./loop.sh plan

# Build with max 10 iterations, interactive confirmation
./loop.sh run build -n 10 -i

# Disable review phase
./loop.sh --no-review

# See all options
./loop.sh --help
```

### Codex login (for reviews)

On remote machines you need device auth to do headless login. First enable this in your ChatGPT / Codex account.

```
codex login --device-auth
```

### Configuration

Create `.ralph/config.toml` to override defaults (default model is `opus`):

```toml
max_iterations = 10
model = "opus"
delay = 5
push_enabled = false
review_enabled = true
review_model = "gpt-5.2-codex"
review_max_revisions = 3
```

### Further reading

- [The Ralph Wiggum Technique](https://ghuntley.com/ralph/) — Geoffrey Huntley's original post
- [how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum) — Reference implementation and methodology guide
- [Inventing the Ralph Wiggum Loop](https://devinterrupted.substack.com/p/inventing-the-ralph-wiggum-loop-creator) — Dev Interrupted podcast interview

