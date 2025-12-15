# Repository Guide (AGENTS)

This repo is an Ansible playbook for configuring a Raspberry Pi (inspired by `geerlingguy/internet-pi`).

## What this repo currently does
- Provisions a Raspberry Pi host (group `raspberry`) via `main.yml`.
- Installs/starts Docker and deploys container stacks into `config_dir` on the Pi.
- Optionally configures services via feature flags in `config.yml`:
  - AdGuard Home (`adguard_enable`)
  - OpenSpeedTest (`open_speed_test_enable`)
  - Watchtower (`watchtower_enable`)
- Includes optional network tuning/config (`tasks/network.yml`).

## Key entrypoints
- `main.yml`: Top-level playbook (imports task files and handlers).
- `config.yml`: Primary configuration (feature flags + service variables).
- `inventory.ini`: Inventory with host(s) in group `raspberry`.
- `requirements.yml`: Ansible collections required by the playbook.

## Repository layout
- `tasks/*.yml`: Ansible task files, imported by `main.yml`.
- `containers/*/docker-compose.yml`: Compose templates copied to the Pi and deployed with `community.docker.docker_compose_v2`.
- `containers/*/*.j2`: Jinja2 template rendered onto the Pi by Ansible.

## Adding a new containerized service (pattern)
1. Add `containers/<service>/docker-compose.yml` (and any templates/assets).
2. Add `tasks/<service>.yml` to:
   - create `{{ config_dir }}/<service>` on the Pi
   - copy/template files into that folder
   - run `community.docker.docker_compose_v2` with `project_src: "{{ config_dir }}/<service>/"`
3. Add an optional handler entry in `tasks/handlers.yml` if restart-on-change is needed.
4. Import it from `main.yml` behind a feature flag in `config.yml`.

## Playbook validation
Use the following command to validate playbook
```bash
uvx --from ansible-core ansible-playbook --syntax-check -i inventory.ini main.yml
uvx --from ansible-core ansible-playbook --check --diff -i inventory.ini main.yml
```

## Playbook execution
Agents should not try to run the playbook, the following command will fail
```bash
uvx --from ansible-core ansible-playbook -i inventory.ini main.yml
```

