# Agent Guidelines for Raspberry-Pi-personal-config

## Project overview
- This repository contains Ansible automation and Docker Compose templates for configuring a Raspberry Pi (network settings, Argon ONE script, Docker installation, unattended upgrades, and optional services like AdGuard Home, OpenSpeedTest, and Watchtower).
- The primary playbook is `main.yml`, which imports task files from the `tasks/` directory and loads defaults from `config.yml`.

## Running the automation
- Use `uv` to run Ansible commands as documented in `README.md`:
  - `uvx --from ansible-core ansible-galaxy collection install -r requirements.yml`
  - `export ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true`
  - `uvx --from ansible-core ansible-playbook -i inventory.ini main.yml`

## Coding conventions
- Prefer `ansible.builtin`/`community.*` module names explicitly, as shown throughout the task files.
- Keep optional services behind feature flags defined in `config.yml` (e.g., `adguard_enable`, `open_speed_test_enable`, `watchtower_enable`).
- When copying Compose templates to the target host, match the existing pattern: create the service directory under `{{ config_dir }}`, copy or template the Compose/config files, then run `community.docker.docker_compose_v2` to ensure the service is running.
- For handler-triggered restarts, add a debug/change-detection step or notify handlers as done in `tasks/adguard.yml` and `tasks/watchtower.yml`.

## Repository structure hints
- `config.yml` holds user-adjustable defaults (config directory, feature flags, DNS settings, and unattended-upgrade overrides).
- `containers/` contains Docker Compose templates and AdGuard configuration (`AdGuardHome.yaml.j2`).
- `tasks/` contains modular task files referenced from `main.yml`; `handlers.yml` centralizes service restarts.
