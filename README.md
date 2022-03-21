# Configuration-management
Ansible homework - OpsSchool
Comments for part2:
1) In order to use dynamic inventory need to create EC2 profile for the server instnce & install boto3 (Use files in config folder)
2) Setup ansible.cfg:
    Open /etc/ansible/ansible.cfg file
    Find the [inventory] section and add the following line to enable the ec2 plugin.
    enable_plugins = aws_ec2
    under defaults. Change the inventory parameter
    inventory      = <path>/aws_ec2.yaml
