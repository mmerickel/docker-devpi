dockerfiles-devpi
=================

This is a tiny recipe for starting devpi within a docker container.

The docker host is assumed to be mapped to ``localdocker`` but may be
anything. Change at will.

Usage
-----

Build the images and setup the client::

  make

An alternate docker host would use something like::

  make DOCKER_HOST=tcp://localdocker:4243

Start the server::

  make run

Setup ``pip``, ``easy_install`` and ``zc.buildout`` to use the new index::

  make config

Upgrading is an export/import process:

1. Export the old data::

     make export
     rm -rf data
     docker rm -f devpi_server

2. Create a new container with the upgraded docker version::

     <edit DOCKER_VERSION in the Makefile>
     make server

3. Import data into the new container::

     make import
     make run
