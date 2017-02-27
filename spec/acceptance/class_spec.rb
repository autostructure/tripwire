require 'spec_helper_acceptance'

describe 'tripwire class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'tripwire':
        master_host        => '10.250.144.45',
        master_port        => 9898,
        master_passcode    => 'fs pass',
        client_installdir  => '/usr/local',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('twdaemon') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
