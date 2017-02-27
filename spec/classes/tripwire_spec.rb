require 'spec_helper'

describe 'tripwire', type: :class do
  let(:params) do
    {
      master_host: '10.250.144.45',
      master_port: 9898,
      master_passcode: 'fs pass',
      client_installdir: '/usr/local',
    }
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "tripwire class without any parameters" do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('tripwire::install').that_comes_before('Class[tripwire::config]') }
          it { is_expected.to contain_class('tripwire::config') }
          it { is_expected.to contain_class('tripwire::service').that_subscribes_to('Class[tripwire::config]') }
          it { is_expected.to contain_service('twdaemon') }

          it {
            is_expected.to contain_exec('installtripagt')
          }

          # it {
          #   is_expected.to contain_file('/etc/init.d/twdaemon').with(
          #     'ensure' => 'file',
          #     'owner'  => 'root',
          #     'group'  => 'root',
          #     'mode'   => '0755'
          #   )
          # }

          # it {
          #   is_expected.to contain_file('/etc/systemd/system/twdaemon').with(
          #     'ensure' => 'file',
          #     'owner'  => 'root',
          #     'group'  => 'root',
          #     'mode'   => '0755'
          #   )
          # }

          it {
            is_expected.to contain_file('/usr/local/te_agent_8.4.2_en_linux_x86_64/te_agent.bin').with(
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root'
            ).that_comes_before('Exec[installtripagt]')
          }
          # it { is_expected.to contain_package('tripwire').with_ensure('present') }
        end
      end
    end
  end

  #  context 'unsupported operating system' do
  #    describe 'tripwire class without any parameters on Solaris/Nexenta' do
  #      let(:facts) do
  #        {
  #          :osfamily        => 'Solaris',
  #          :operatingsystem => 'Nexenta',
  #        }
  #      end

  #      it { expect { is_expected.to contain_package('tripwire') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
  #    end
  #  end
end
