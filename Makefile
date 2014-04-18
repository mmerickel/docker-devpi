PYTHON_BIN=python
VIRTUALENV=virtualenv
DATA=$(PWD)/data

PIP_CONF=$(HOME)/.pip/pip.conf
SETUPTOOLS_CONF=$(HOME)/.pydistutils.cfg
BUILDOUT_CONF=$(HOME)/.buildout/default.cfg

DEVPI_PORT=3141
DEVPI_HOST=localdocker
DEVPI_URL=http://$(DEVPI_HOST):$(DEVPI_PORT)/root/pypi

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
	docker run -d --name devpi_server -p $(DEVPI_PORT):3141 -v $(DATA):/data devpi-server

.PHONY: config
config:
	$(PYTHON_BIN) install_config.py $(DEVPI_URL)
