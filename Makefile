PYTHON_BIN=python
VIRTUALENV=virtualenv
DATA=$(PWD)/data

PIP_CONF=$(HOME)/.pip/pip.conf
SETUPTOOLS_CONF=$(HOME)/.pydistutils.cfg
BUILDOUT_CONF=$(HOME)/.buildout/default.cfg

DEVPI_PORT=3141
DEVPI_HOST=localdocker
DEVPI_URL=http://$(DEVPI_HOST):$(DEVPI_PORT)/root/pypi/+simple
DEVPI_VERSION=2.1.4

.PHONY: all
all: server client

venv:
	$(VIRTUALENV) -p $(PYTHON_BIN) venv

.PHONY: client
client: venv
	venv/bin/pip install "devpi==$(DEVPI_VERSION)"

devpi-server/versions/$(DEVPI_VERSION)/Dockerfile: devpi-server/Dockerfile.template
	mkdir -p devpi-server/versions/$(DEVPI_VERSION)
	cat devpi-server/Dockerfile.template | sed -e "s/{{[ ]*DEVPI_VERSION[ ]*}}/$(DEVPI_VERSION)/g" > $@

.PHONY: server
server: devpi-server/versions/$(DEVPI_VERSION)/Dockerfile
	docker build -t devpi-server:$(DEVPI_VERSION) devpi-server/versions/$(DEVPI_VERSION)

.PHONY: run
run:
	mkdir -p $(DATA)
	docker run -d --restart always --name devpi_server -p $(DEVPI_PORT):3141 -v $(DATA):/data devpi-server:$(DEVPI_VERSION)

.PHONY: config
config:
	$(PYTHON_BIN) install_config.py $(DEVPI_URL)
