require_relative '../spec_helper'

describe rds(ENV['concourse_db_id']) do
  it { should have_security_group('sg-47df2e36') }
  it { should belong_to_db_subnet_group('temp_postgres') }
  it { should belong_to_vpc('vpc-89ff52f0') }
end

describe ec2(ENV['concourse_instance_id']) do
  it { should have_security_group('sg-47df2e36') }
  it { should belong_to_subnet('subnet-1f359c33') }
  it { should belong_to_vpc('vpc-89ff52f0') }
end