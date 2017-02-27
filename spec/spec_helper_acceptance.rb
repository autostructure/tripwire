require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

# ENV['PUPPET_INSTALL_TYPE'] = 'foss'
# ENV['PUPPET_INSTALL_VERSION'] = '4.8'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = %w(Windows Solaris AIX).freeze

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(source: proj_root, module_name: 'tripwire')

    # install_puppet_on(hosts)

    hosts.each do |host|
      # puppet_module_install(:source => proj_root, :module_name => 'appinternals')
      # version = ENV['PUPPET_INSTALL_VERSION'] || '4.8.0'
      # install_puppet(:version => version)

      on host, puppet('module', 'install', 'autostructure-staging'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
    end
  end
end
