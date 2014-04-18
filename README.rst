docker-devpi
============

This is a tiny recipe for starting devpi within a docker container.

The docker host is assumed to be mapped to ``localdocker`` but may be
anything. Change at will.

Usage
-----

Build the images and setup the client::

  make

Start the server::

  make run

Setup ``pip``, ``easy_install`` and ``zc.buildout`` to use the new index::

  make config
