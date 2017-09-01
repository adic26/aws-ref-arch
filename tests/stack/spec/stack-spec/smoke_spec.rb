require_relative '../spec_helper'
require 'pry'

describe ENV['live_elb_hostname'] do
  it "should have empty results" do
    resultSet = `curl -s #{ENV['live_fqdn']}#{ENV['ping_path']}/toggles | jq ."response.results"`.split[0]
    expect(resultSet).to eq "[]"
  end

  it "should have no errors" do
    resultSet = `curl -s #{ENV['live_fqdn']}#{ENV['ping_path']}/toggles | jq ."errors"`.split[0]
    expect(resultSet).to eq "[]"
  end
end

describe ENV['dark_elb_hostname'] do
  it "should have empty results" do
    resultSet = `curl -s #{ENV['dark_fqdn']}#{ENV['ping_path']}/toggles | jq ."response.results"`.split[0]
    expect(resultSet).to eq "[]"
  end

  it "should have no errors" do
    resultSet = `curl -s #{ENV['dark_fqdn']}#{ENV['ping_path']}/toggles | jq ."errors"`.split[0]
    expect(resultSet).to eq "[]"
  end
end