🌞 **Constater le déploiement**

	az vm list:
	
	"location": "westeurope",
    "managedBy": null,
    "name": "tp2magueule-vm"

🌞 **Créer un _plan Terraform_ avec les contraintes suivantes**

- `node1`
    - Ubuntu 22.04
    - 104.40.212.83
    - 10.0.2.4
- `node2`
    - Ubuntu 22.04
    - 10.0.2.5
- les IPs privées doivent permettre aux deux machines de se `ping`

	tp3node-node1:~$ ping 10.0.2.5
	PING 10.0.2.5 (10.0.2.5) 56(84) bytes of data.
	64 bytes from 10.0.2.5: icmp_seq=1 ttl=64 time=4.32 ms
	64 bytes from 10.0.2.5: icmp_seq=2 ttl=64 time=2.35 ms
	64 bytes from 10.0.2.5: icmp_seq=3 ttl=64 time=1.50 ms
	^C
	--- 10.0.2.5 ping statistics ---
	3 packets transmitted, 3 received, 0% packet loss, time 2003ms
	rtt min/avg/max/mdev = 1.497/2.722/4.317/1.180 ms

