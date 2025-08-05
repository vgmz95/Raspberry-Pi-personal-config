# Raspberry Pi personal configuration
docker-compose and ansible playbook files (based on https://github.com/geerlingguy/internet-pi)

## Steps
- Assign static address to Pi:  https://pimylifeup.com/raspberry-pi-static-ip-address/
- Configure ssh login without password: https://www.raspberrypi.com/documentation/computers/remote-access.html#configure-ssh-without-a-password
- Install [uv](https://github.com/astral-sh/uv?tab=readme-ov-file#installation)
- Run playbook:
```
uvx --from ansible-core ansible-galaxy collection install -r requirements.yml
uvx --from ansible-core ansible-playbook -i inventory.ini main.yml
```
