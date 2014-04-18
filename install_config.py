#!/usr/bin/env python
from __future__ import print_function
import argparse
import io
import os
import os.path
import sys

try:
    from ConfigParser import ConfigParser
except ImportError:
    from configparser import ConfigParser

def mkdir(path):
    if not os.path.exists(path):
        print('creating missing directory "%s"' % path)
        os.makedirs(path)

def mkpath(path):
    realpath = os.path.normpath(os.path.expanduser(path))
    mkdir(os.path.dirname(realpath))
    return realpath

def add_ini_param(path, section, key, value):
    cfg = ConfigParser()
    if os.path.exists(path):
        cfg.read(path)
    if not cfg.has_section(section):
        cfg.add_section(section)
    if cfg.has_option(section, key):
        orig_value = cfg.get(section, key)
        if orig_value == value:
            print('already up to date')
            return
        else:
            print('overwriting %s' % key)
    cfg.set(section, key, value)
    with io.open(path, 'wb') as fp:
        cfg.write(fp)

def install_pip_cfg(url):
    path = mkpath('~/.pip/pip.conf')
    print('installing pip configuration "%s"' % path)
    add_ini_param(path, 'global', 'index-url', url)

def install_setuptools_cfg(url):
    path = mkpath('~/.pydistutils.cfg')
    print('installing setuptools configuration "%s"' % path)
    add_ini_param(path, 'easy_install', 'index_url', url)

def install_buildout_cfg(url):
    path = mkpath('~/.buildout/default.cfg')
    print('installing buildout configuration "%s"' % path)
    add_ini_param(path, 'buildout', 'index', url)

def parse_args(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('url', help='custom PyPI index endpoint')
    parser.add_argument('--no-pip', action='store_true', default=False)
    parser.add_argument('--no-setuptools', action='store_true', default=False)
    parser.add_argument('--no-buildout', action='store_true', default=False)
    return parser.parse_args(argv)

def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    args = parse_args(argv)

    url = args.url
    if not args.no_pip:
        install_pip_cfg(url)
    if not args.no_setuptools:
        install_setuptools_cfg(url)
    if not args.no_buildout:
        install_buildout_cfg(url)

if __name__ == '__main__':
    sys.exit(main() or 0)
