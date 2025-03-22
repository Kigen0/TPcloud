🌞 **Construire votre propre image**

- Dockerfile

	FROM ubuntu
	
	RUN apt update -y
	RUN apt install -y apache2
	
	COPY apache2.conf /etc/apache2/apache2.conf
	
	COPY index.html /var/www/html/index.html
	
	CMD [ "apache2", "-DFOREGROUND" ]

