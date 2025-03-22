🌞 **Installez un WikiJS** en utilisant Docker

	mkdir wikijs && cd wikijs

	nano docker-compose.yml

	services:
	  db:
	    image: postgres:13
	    environment:
	      POSTGRES_DB: wiki
	      POSTGRES_PASSWORD: password
	      POSTGRES_USER: admin
	    volumes:
	      - dbdata:/var/lib/postgresql/data
	    restart: always
	
	  wikijs:
	    image: requarks/wiki:2
	    ports:
	      - "80:3000"
	    environment:
	      DB_TYPE: postgres
	      DB_HOST: db
	      DB_PORT: 5432
	      DB_USER: wikijs
	      DB_PASS: password
	      DB_NAME: wiki
	    depends_on:
	      - db
	    restart: always

	docker compose up -d

🌞 **Vous devez :**

	sudo nano Dockerfile

	FROM python:3.11-slim
	
	WORKDIR /app
	
	COPY requirements.txt .
	RUN pip install --no-cache-dir -r requirements.txt
	
	COPY . .
	
	CMD ["python", "app.py"]

	sudo nano docker-compose.yml

	services:
	  redis:
	    image: redis:latest
	    container_name: redis
	    restart: always
	
	  myapp:
	    build: .
	    ports:
	      - "8888:8888"
	    depends_on:
	      - redis

	docker compose up --build -d

