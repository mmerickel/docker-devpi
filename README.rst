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

Setup ``pip`` to use the new index::

  echo 'export PIP_INDEX_URL=http://localdocker:3141/root/pypi' > ~/.zshrc

Setup ``easy_install`` to use the new index::

  cat << EOF > ~/.pydistutils.cfg
  [easy_install]$
  index-url = http://localdocker:3141/root/pypi
  EOF
