# == Class tripwire::install
#
# This class is called from tripwire for install.
#
class tripwire::install {
  $server_host = "--server-host ${::tripwire::master_host}"
  $master_port = "--server-port ${::tripwire::master_port}"
  $passphrase = "--passphrase ${::tripwire::master_passcode}"

  file { "${::tripwire::client_installdir}/te_agent_8.6.0.2_en_linux_x86_64/te_agent.bin" :
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    before => Exec['installtripagt'],
  }

  exec { 'installtripagt':
    cwd       => "${::tripwire::client_installdir}/te_agent_8.6.0.2_en_linux_x86_64/",
    path      => ["${::tripwire::client_installdir}/te_agent_8.6.0.2_en_linux_x86_64",'/bin','/usr/bin'],
    command   => "te_agent.bin ${server_host} ${master_port} ${passphrase} --eula accept --silent   --enable-fips",
    creates   => "${::tripwire::client_installdir}/tripwire/te/agent/bin/",
    logoutput => true,
    timeout   => 1800,
  }
}
