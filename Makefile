PYTHON_BIN=python
VIRTUALENV=virtualenv
DATA=$(PWD)/data
EXPORTDATA=$(PWD)/export

PIP_CONF=$(HOME)/.pip/pip.conf
SETUPTOOLS_CONF=$(HOME)/.pydistutils.cfg
BUILDOUT_CONF=$(HOME)/.buildout/default.cfg

DEVPI_PORT=3141
DEVPI_HOST=localdocker
DEVPI_URL=http://$(DEVPI_HOST):$(DEVPI_PORT)/root/pypi/+simple
DEVPI_VERSION=2.2.1

.PHONY: all
all: server client

venv:
	$(VIRTUALENV) -p "$(PYTHON_BIN)" venv

.PHONY: client
client: venv
	venv/bin/pip install devpi-client

devpi-server/versions/$(DEVPI_VERSION)/Dockerfile: devpi-server/Dockerfile.template
	mkdir -p devpi-server/versions/$(DEVPI_VERSION)
	cat devpi-server/Dockerfile.template | sed -e "s/{{[ ]*DEVPI_VERSION[ ]*}}/$(DEVPI_VERSION)/g" > $@

.PHONY: server
server: devpi-server/versions/$(DEVPI_VERSION)/Dockerfile
	docker build -t devpi-server:$(DEVPI_VERSION) devpi-server/versions/$(DEVPI_VERSION)

.PHONY: run
run:
	mkdir -p "$(DATA)"
	docker run -d --restart always --name devpi_server -p $(DEVPI_PORT):3141 -v "$(DATA):/data" devpi-server:$(DEVPI_VERSION)

.PHONY: config
config:
	"$(PYTHON_BIN)" install_config.py "$(DEVPI_URL)"

export:
	mkdir -p "$(EXPORTDATA)"
	docker run --rm --volumes-from devpi_server -v "$(EXPORTDATA):/data-dump" devpi-server:$(DEVPI_VERSION) --export /data-dump

import:
	mkdir -p "$(DATA)"
	docker run --rm -v "$(DATA):/data" -v "$(EXPORTDATA):/data-import" devpi-server:$(DEVPI_VERSION) --import /data-import
