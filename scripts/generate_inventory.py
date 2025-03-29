import json

# Load Terraform output
with open("terraformfiles/tf_output.json") as f:
    tf_output = json.load(f)

# Extract instance IPs from Terraform output
instance_ips = tf_output.get("server_ips", {}).get("value", [])

# Generate inventory file
with open("inventory", "w") as inv:
    inv.write("[web]\n")
    for ip in instance_ips:
        inv.write(f"{ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa\n")
