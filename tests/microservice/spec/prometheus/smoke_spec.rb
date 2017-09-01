require_relative '../spec_helper'
require 'rest-client'
require 'pry'


describe 'prometheus' do
  it "should respond with 200" do
    response = timeout(180) { RestClient.get "#{ENV['prometheus_elb_hostname']}#{ENV['prometheus_ping_path']}" }

    expect(response.code).to eq 200
  end
end

