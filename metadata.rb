maintainer       "Thinking Phone Networks, Inc."
maintainer_email "Leif Madsen <lmadsen@thinkingphones.com>"
license          "Apache 2.0"
description      "Installs/Configures gerrit"
name             "gerrit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

supports "centos"
supports "redhat"
supports "scientific"
supports "fedora"

depends "java"
depends "mysql"
depends "database"
depends "git"
depends "build-essential"
