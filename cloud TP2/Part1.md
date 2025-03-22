🌞 **Créez une VM depuis le Azure CLI**

	az vm create -g VM_group -n super_vm --image Ubuntu2204 --admin-username azureuser --ssh-key-values ./.ssh/id_rsa.pub

	{
	  "location": "eastus",
	  "macAddress": "60-45-BD-D4-44-14",
	  "powerState": "VM running",
	  "privateIpAddress": "10.1.0.5",
	  "publicIpAddress": "172.206.199.150",
	  "resourceGroup": "VM_group",
	  "zones": ""
	}

🌞 **Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique.**

	sudo systemctl status walinuxagent
	● walinuxagent.service - Azure Linux Agent
	     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset:>
	     Active: active (running) since Thu 2025-03-20 10:06:29 UTC; 4min 3s ago
	   Main PID: 764 (python3)
	      Tasks: 7 (limit: 4023)
	     Memory: 42.9M
	        CPU: 2.105s
	     CGroup: /system.slice/walinuxagent.service
	             ├─ 764 /usr/bin/python3 -u /usr/sbin/waagent -daemon
	             └─1091 python3 -u bin/WALinuxAgent-2.13.1.1-py3.9.egg -run-exthandlers

	sudo systemctl status cloud-init
	● cloud-init.service - Cloud-init: Network Stage
	     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: e>
	     Active: active (exited) since Thu 2025-03-20 10:06:29 UTC; 4min 27s ago
	   Main PID: 513 (code=exited, status=0/SUCCESS)
	        CPU: 1.899s

	cloud-init status
	status: done

🌞 **Créez deux VMs depuis le Azure CLI**

	VM1 10.1.0.5; VM2 10.1.0.6
	
	ping 10.1.0.5
	PING 10.1.0.5 (10.1.0.5) 56(84) bytes of data.
	64 bytes from 10.1.0.5: icmp_seq=1 ttl=64 time=0.034 ms
	64 bytes from 10.1.0.5: icmp_seq=2 ttl=64 time=0.050 ms
	64 bytes from 10.1.0.5: icmp_seq=3 ttl=64 time=0.054 ms
	^C
	--- 10.1.0.5 ping statistics ---
	3 packets transmitted, 3 received, 0% packet loss, time 2061ms
	rtt min/avg/max/mdev = 0.034/0.046/0.054/0.008 ms