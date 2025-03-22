🌞 **Tester `cloud-init`**

	

🌞 **Utilisez `cloud-init` pour préconfigurer la VM :**

	az vm create -g VM_group -n vm-init --image Ubuntu2204 --custom-data C:\Users\Nolac\Documents\cloud-init.txt --admin-username azureuzer

	#cloud-config

	package_update: true
	package_upgrade: true
	packages:
	  - docker.io
	
	runcmd:
	  - usermod -aG docker $USER
	  - docker pull alpine:latest
	
	users:
	  - default
	  - name: Admin
	    sudo: ALL=(ALL) NOPASSWD:ALL
	    shell: /bin/bash
	    groups: docker, sudo
	    lock_passwd: false
	    passwd: Password
	    ssh_authorized_keys:
	      - ssh-rsa ......

	  "location": "eastus",
	  "macAddress": "7C-1E-52-14-AB-6C",
	  "powerState": "VM running",
	  "privateIpAddress": "10.1.0.5",
	  "publicIpAddress": "172.174.38.218",
	  "resourceGroup": "VM_group",
	  "zones": ""
	}