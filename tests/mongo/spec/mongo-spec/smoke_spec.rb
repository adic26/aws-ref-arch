require_relative '../spec_helper'
require 'pry'

describe "MongoDB Connection" do

  let!(:admin_password) { `aws ssm get-parameters --with-decryption --names /toggle-service/test/test/mongoAdminPassword | jq ."Parameters[0].Value" --raw-output`.strip }

  it "should authenticate with db" do
      response = timeout(600) { mongo_login(admin_password) }
      expect(response).to equal true
  end

  it "should have a replica set" do
    primary = `echo "rs.status().members[0].stateStr == 'PRIMARY'" | mongo -u some -p #{admin_password} #{ENV['ip']}:27017/admin --quiet`.split[0]
    expect(primary).to eq 'true'

    secondary0 = `echo "rs.status().members[1].stateStr == 'SECONDARY'" | mongo -u some -p #{admin_password} #{ENV['ip']}:27017/admin --quiet`.split[0]
    expect(secondary0).to eq 'true'

    secondary1 = `echo "rs.status().members[2].stateStr == 'SECONDARY'" | mongo -u some -p #{admin_password} #{ENV['ip']}:27017/admin --quiet`.split[0]
    expect(secondary1).to eq 'true'
  end
end

def mongo_login(admin_password)
  `echo "db.stats().ok" | mongo -u some -p #{admin_password} #{ENV['ip']}:27017/admin --quiet`
  if $?.exitstatus != 0
    raise StandardError
  else
    true
  end
end
