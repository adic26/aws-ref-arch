require_relative '../spec_helper'
require 'rest-client'
require 'pry'

describe ENV['live_elb_hostname'] do
  it "should respond with 200 with fqdn" do
    response = timeout(180) { RestClient.get "#{ENV['live_fqdn']}#{ENV['ping_path']}" }

    expect(response.code).to eq 200
  end
end

describe ENV['dark_elb_hostname'] do
  it "should respond with 200 with fqdn" do
    response = timeout(180) { RestClient.get "#{ENV['dark_fqdn']}#{ENV['ping_path']}" }

    expect(response.code).to eq 200
  end
end
