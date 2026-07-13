# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Ansible playbook that provisions a single Raspberry Pi (inspired by `geerlingguy/internet-pi`). It installs Docker and deploys self-hosted container stacks (DNS, speed testing, auto-updates) via `community.docker.docker_compose_v2`.

## Commands

```bash
# Install Python tooling + Ansible collections (once)
uv sync
uv run ansible-galaxy collection install -r requirements.yml

# Static validation (safe without the Pi)
uv run ansible-playbook --syntax-check -i inventory.ini main.yml
uv run ansible-lint

# Run against the Pi (requires network access + SSH to the host)
export ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true
uv run ansible-playbook -i inventory.ini main.yml
```

`ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true` is required at run time because `tasks/docker.yml` calls `meta: reset_connection`, which does not support the surrounding conditional logic. Do not remove it.

Prefer `uv run` for all Python/Ansible execution (backed by `pyproject.toml` + `uv.lock`). In an environment without access to the actual Pi, only run the syntax-check and lint commands — do not attempt a real playbook run.

## Architecture

- **`main.yml`** — the single playbook. Runs on host group `raspberry` with `become: true`, loads `config.yml` in `pre_tasks`, then imports each `tasks/*.yml` file in order. Service task files are gated by `when: <service>_enable`.
- **`config.yml`** — the only place to change behavior: feature flags (`blocky_enable`, `adguard_enable`, etc.), `config_dir` (where compose files land on the Pi, default `~/containers`), and per-service variables.
- **`tasks/*.yml`** — one file per concern. `docker.yml`, `network.yml`, `argonone.yml`, and `unattended_upgrades.yml` always run; the rest are service deployments behind flags.
- **`containers/<service>/`** — compose files and Jinja2 (`.j2`) templates that get copied/rendered onto the Pi under `{{ config_dir }}/<service>/`.
- **`inventory.ini`** — the target host (static IP in group `raspberry`).

Note: most container tasks use `become: false` even though the play sets `become: true` — Docker runs as the unprivileged `ansible_user`, who is added to the `docker` group in `tasks/docker.yml`.

## Adding a containerized service

1. Create `containers/<service>/docker-compose.yml` (plus any `.j2` templates).
2. Create `tasks/<service>.yml` that: creates `{{ config_dir }}/<service>` (`become: false`), copies/templates the compose file (with `notify: Restart <service>` if applicable), and runs `community.docker.docker_compose_v2` with `project_src: "{{ config_dir }}/<service>/"` and `build: never`.
3. Add a matching `Restart <service>` handler in `tasks/handlers.yml`.
4. Add a feature flag to `config.yml` and import the task in `main.yml` behind `when: <service>_enable`.
