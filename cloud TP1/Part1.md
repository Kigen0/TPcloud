🌞 **Installer Docker votre machine Azure**

	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	
	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	```console
	 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	```
	
- démarrer le service `docker` avec une commande `systemctl`

	systemctl start docker

- ajouter votre utilisateur au groupe `docker`

	sudo usermod -aG docker $(whoami)

🌞 **Utiliser la commande `docker run`**

	docker run --name web -d -p 9999:80 nginx

🌞 **Rendre le service dispo sur internet**

	curl 20.84.58.96
	<!DOCTYPE html>
	<html>
	<head>
	<title>Welcome to nginx!</title>
	<style>
	html { color-scheme: light dark; }
	body { width: 35em; margin: 0 auto;
	font-family: Tahoma, Verdana, Arial, sans-serif; }
	</style>
	</head>
	<body>
	<h1>Welcome to nginx!</h1>
	<p>If you see this page, the nginx web server is successfully installed and
	working. Further configuration is required.</p>
	
	<p>For online documentation and support please refer to
	<a href="http://nginx.org/">nginx.org</a>.<br/>
	Commercial support is available at
	<a href="http://nginx.com/">nginx.com</a>.</p>
	
	<p><em>Thank you for using nginx.</em></p>
	</body>
	</html>

🌞 **Custom un peu le lancement du conteneur**

	docker run --name meow -v /home/docker/toto.conf:/etc/nginx/conf.d/toto.conf -v /home/docker/index.html:/var/www/tp_docker -m 512m -d -p 9999:7777 nginx