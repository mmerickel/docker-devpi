PYTHON_BIN=python
VIRTUALENV=virtualenv
DATA=$(pwd)/data

.PHONY: all
all: server client

venv:
	$(VIRTUALENV) -p $(PYTHON_BIN) venv

.PHONY: client
client: venv
	venv/bin/pip install -U devpi

.PHONY: server
server:
	docker build -t devpi-server devpi-server

.PHONY: run
run:
	mkdir -p $(DATA)
	docker run -d --name devpi-server -p 3141:3141 -v $(DATA):/data devpi-server
