Description
===========
Installs and configures the Gerrit, a web based code review and project management tool for Git based projects.

Requirements
============

Chef 0.10.10+

Platform
--------

* CentOS, Red Hat, Fedora

Tested on:

* CentOS 6.3

Cookbooks
---------

Requires Opscode's `java`, `mysql` and `database` cookbooks. See _Attributes_ and _Usage_ for more information.

Attributes
==========

# basic options
* `node['gerrit']['username']` = 'gerrit2'
* `node['gerrit']['db_password']` = 'welcome'
* `node['gerrit']['version']` = '2.5.1'

# main paths
* `node['gerrit']['home_dir']` = '/home/gerrit2'
* `node['gerrit']['base_dir']` = 'review_site'

# default options for gerrit.config
# -- for internal DB usage
#`node['gerrit']['database']['type']` = 'H2'
#`node['gerrit']['database']['database']` = 'db/ReviewDB'

# -- for mysql based DB usage
* `node['gerrit']['database']['type']` = 'MYSQL'
* `node['gerrit']['database']['database']` = 'reviewdb'

# authentication types and control
* `node['gerrit']['auth']['type']` = 'LDAP'

# ldap authentication methods
* `node['gerrit']['auth']['ldap']['server']` = 'ldap.your_domain.com'
* `node['gerrit']['auth']['ldap']['username']` = 'cn=Directory Manager,dc=your_domain,dc=com'
* `node['gerrit']['auth']['ldap']['password']` = 'welcome'
* `node['gerrit']['auth']['ldap']['account_base']` = 'cn=common_name,ou=people,dc=your_domain,dc=com'
* `node['gerrit']['auth']['ldap']['account_scope']` = 'subtree'
* `node['gerrit']['auth']['ldap']['account_pattern']` = '(& (objectclass=domain-user) (doman-active=1) (uid=${username}) )'
* `node['gerrit']['auth']['ldap']['account_fullname']` = 'cn'
* `node['gerrit']['auth']['ldap']['account_email_address']` = 'mail'
* `node['gerrit']['auth']['ldap']['group_base']` = 'ou=internal,ou=acls,dc=your_domain,dc=com'
* `node['gerrit']['auth']['ldap']['group_scope']` = 'subtree'
* `node['gerrit']['auth']['ldap']['group_pattern']` = '(cn=${groupname})'
* `node['gerrit']['auth']['ldap']['group_member_pattern']` = '(uniqueMember=${username})'
* `node['gerrit']['auth']['ldap']['local_username_to_lowercase']` = true

# listening interfaces
* `node['gerrit']['sshd']['listen_address']` = '*:29418'
* `node['gerrit']['httpd']['listen_url']` = 'http://*:8080/'


Usage
=====

