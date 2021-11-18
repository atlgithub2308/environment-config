## site.pp ##

# This file (./manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
# https://puppet.com/docs/puppet/latest/dirs_manifest.html
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition if you want to use it.

## Active Configurations ##

# Disable filebucket by default for all File resources:
# https://github.com/puppetlabs/docs-archive/blob/master/pe/2015.3/release_notes.markdown#filebucket-resource-no-longer-created-by-default
File { backup => false }

## Node Definitions ##

# The default node definition matches any node lacking a more specific node
# definition. If there are no other node definitions in this file, classes
# and resources declared in the default node definition will be included in
# every node's catalog.
#
# Note that node definitions in this file are merged with node data from the
# Puppet Enterprise console and External Node Classifiers (ENC's).
#
# For more on node definitions, see: https://puppet.com/docs/puppet/latest/lang_node_definitions.html

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  # class { 'my_class': }
  # include java::install
  # include java
  # notify { " Node ${fqdn} has no node definition": }

  user { ['sysad1']:
    ensure => present
  }
}

node 'primary.atldemo.net' {

  user { ['sysad1']:
    ensure => present,
  }

#  ini_setting { 'policy-based autosigning':
#    setting => 'autosign',
#    path    => '/etc/puppetlabs/puppet/puppet.conf',
#    section => 'master',
#    value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
#    notify  => Service['pe-puppetserver'],
#  }

#  class { ::autosign:
#    ensure => 'latest',
#    config => {
#      'general' => {
#        'loglevel' => 'INFO',
#      },
#      'jwt_token' => {
#        'secret'   => 'hunter2',
#        'validity' => '7200',
#      }
#    },
#  }
}

node 'redhat1.atldemo.net' {
  lookup('role').include
  #include mongodb::server


  class {'mongodb::globals':
    manage_package_repo => false,
    version             => '5.0',
  }
  -> class {'mongodb::server': }

}

node 'debian1.atldemo.net' {
  lookup('role').include
}

node 'dev-debian.atldemo.net' {
  lookup('role').include
}

node 'windows1.atldemo.net' {
  include winservice
}
