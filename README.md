# Raspberry Pi personal configuration
docker-compose and ansible playbook files (based on https://github.com/geerlingguy/internet-pi)

## Steps
- Assign static address to Pi:  https://pimylifeup.com/raspberry-pi-static-ip-address/
- Install ansible: https://github.com/geerlingguy/internet-pi?tab=readme-ov-file#setup
- Configure ssh login without password: https://www.raspberrypi.com/documentation/computers/remote-access.html#configure-ssh-without-a-password
- Run playbook: `ansible-playbook -i inventory.ini main.yml`
