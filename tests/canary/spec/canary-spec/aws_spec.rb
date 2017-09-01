require_relative '../spec_helper'

describe autoscaling_group(ENV['live_asg_name']) do
  it { should have_elb(ENV['live_elb_name']) }
end

describe autoscaling_group(ENV['dark_asg_name']) do
  it { should have_elb(ENV['dark_elb_name']) }
end

