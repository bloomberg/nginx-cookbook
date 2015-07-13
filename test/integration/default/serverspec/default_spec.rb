require 'serverspec'
require 'spec_helper'

describe package('nginx') do
  it { is_expected.to be_installed }
end

describe service('nginx') do
  it { is_expected.to be_running }
end

describe file('/etc/nginx/sites-available/www') do
  it { is_expected.to be_file }
  its(:content) { is_expected.to match(/server_name www.example.com;/) }
end

describe file('/etc/nginx/sites-enabled/www') do
  it { is_expected.to be_symlink }
  it { is_expected.to be_linked_to "/etc/nginx/sites-available/www.example.com" }
end
