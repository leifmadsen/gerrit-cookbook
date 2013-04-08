# basic options
default['gerrit']['username'] = 'gerrit2'
default['gerrit']['db_password'] = 'welcome'
default['gerrit']['version'] = '2.5.1'

# main paths
default['gerrit']['home_dir'] = '/home/gerrit2'
default['gerrit']['base_dir'] = 'review_site'

# default options for gerrit.config
# -- for internal DB usage
#default['gerrit']['database']['type'] = 'H2'
#default['gerrit']['database']['database'] = 'db/ReviewDB'

# -- for mysql based DB usage
default['gerrit']['database']['type'] = 'MYSQL'
default['gerrit']['database']['database'] = 'reviewdb'

# authentication types and control
default['gerrit']['auth']['type'] = 'LDAP'

# ldap authentication methods
default['gerrit']['auth']['ldap']['server'] = 'ldap.your_domain.com'
default['gerrit']['auth']['ldap']['username'] = 'cn=Directory Manager,dc=your_domain,dc=com'
default['gerrit']['auth']['ldap']['password'] = 'welcome'
default['gerrit']['auth']['ldap']['account_base'] = 'cn=common_name,ou=people,dc=your_domain,dc=com'
default['gerrit']['auth']['ldap']['account_scope'] = 'subtree'
default['gerrit']['auth']['ldap']['account_pattern'] = '(& (objectclass=domain-user) (domain-active=1) (uid=${username}) )'
default['gerrit']['auth']['ldap']['account_fullname'] = 'cn'
default['gerrit']['auth']['ldap']['account_email_address'] = 'mail'
default['gerrit']['auth']['ldap']['group_base'] = 'ou=internal,ou=acls,dc=your_domain,dc=com'
default['gerrit']['auth']['ldap']['group_scope'] = 'subtree'
default['gerrit']['auth']['ldap']['group_pattern'] = '(cn=${groupname})'
default['gerrit']['auth']['ldap']['group_member_pattern'] = '(uniqueMember=${username})'
default['gerrit']['auth']['ldap']['local_username_to_lowercase'] = true

# listening interfaces
default['gerrit']['sshd']['listen_address'] = '*:29418'
default['gerrit']['httpd']['listen_url'] = 'http://*:8080/'
