require 'spec_helper'

describe('icingaweb2::module::monitoring', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ido_type 'mysql' and commandtransport 'api'" do
      let(:params) { { :ido_type => 'mysql',
                       :ido_host => 'localhost',
                       :ido_db_name => 'icinga2',
                       :ido_db_username => 'icinga2',
                       :ido_db_password => 'icinga2',
											 :commandtransports => {
											   'foo' => {
												   'username' => 'root',
													 'password' => 'foobar',
												 }
											 } } }


      it { is_expected.to contain_icingaweb2__module('monitoring')
        .with_install_method('none')
        .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
        .with_settings({
                           'module-monitoring-backends'=>{
                               'section_name' => 'backends',
                               'target'=>'/etc/icingaweb2/modules/monitoring/backends.ini',
                               'settings'=>{
                                   'type'=>'ido',
                                   'resource'=>'icingaweb2-module-monitoring'
                               }
                           },
                           'module-monitoring-config'=>{
                               'section_name' => 'config',
                               'target'=>'/etc/icingaweb2/modules/monitoring/config.ini',
                               'settings'=>{
                                   'protected_customvars'=>'*pw*, *pass*, community'
                               }
                           }
                       }) }

			it { is_expected.to contain_icingaweb2__config__resource('icingaweb2-module-monitoring')
				.with_type('db')
				.with_db_type('mysql')
				.with_host('localhost')
				.with_port('3306')
				.with_db_name('icinga2')
				.with_db_username('icinga2')
				.with_db_password('icinga2')
			}

			it { is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
				.with_username('root')
				.with_password('foobar')
			}
    end

    context "#{os} with ido_type 'pgsql' and commandtransport 'local'" do
      let(:params) { { :ido_type => 'pgsql',
                       :ido_host => 'localhost',
											 :ido_port => 5432,
                       :ido_db_name => 'icinga2',
                       :ido_db_username => 'icinga2',
                       :ido_db_password => 'icinga2',
											 :commandtransports => {
											   'foo' => {
												   'transport' => 'local',
												 }
											 } } }

      it { is_expected.to contain_icingaweb2__module('monitoring')
        .with_install_method('none')
        .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
        .with_settings({
                           'module-monitoring-backends'=>{
                               'section_name' => 'backends',
                               'target'=>'/etc/icingaweb2/modules/monitoring/backends.ini',
                               'settings'=>{
                                   'type'=>'ido',
                                   'resource'=>'icingaweb2-module-monitoring'
                               }
                           },
                           'module-monitoring-config'=>{
                               'section_name' => 'config',
                               'target'=>'/etc/icingaweb2/modules/monitoring/config.ini',
                               'settings'=>{
                                   'protected_customvars'=>'*pw*, *pass*, community'
                               }
                           }
                       }) }

			it { is_expected.to contain_icingaweb2__config__resource('icingaweb2-module-monitoring')
				.with_type('db')
				.with_db_type('pgsql')
				.with_host('localhost')
				.with_port(5432)
				.with_db_name('icinga2')
				.with_db_username('icinga2')
				.with_db_password('icinga2')
			}

			it { is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
				.with_transport('local')
			}
    end

    context "#{os} with invalid ido_type" do
      let(:params) { { :ido_type => 'foobar' } }

      it { is_expected.to raise_error(Puppet::Error, /foobar isn't supported/) }
    end

  end
end
