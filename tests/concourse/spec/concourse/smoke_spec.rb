require 'rest-client'
require 'pry'
require_relative '../spec_helper'

describe ENV['concourse_dns'] do
  it "should respond with 200" do
    response = timeout(180) { RestClient.get "#{ENV['concourse_dns']}" }

    expect(response.code).to eq 200
  end
end