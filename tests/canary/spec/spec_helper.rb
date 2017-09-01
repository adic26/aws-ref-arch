require 'awspec'
require 'json'

def terraform(command)
  Dir.chdir('..') do
    terraform_command = "terraform #{command}"
    puts "$ #{terraform_command}"
    `#{terraform_command}`.strip
  end
end

def terraform_stream_output(command)
  Dir.chdir('..') do
    terraform_command = "terraform #{command}"
    puts "$ #{terraform_command}"
    puts `#{terraform_command}`
  end
end

terraform_stream_output 'init -force-copy'

terraform_stream_output 'apply'

terraform_raw_output = terraform 'output -json'

terraform_output = JSON.parse(terraform_raw_output)


ENV['dark_elb_hostname'] = terraform_output['dark_component']['value']['elb_hostname']
ENV['dark_elb_name'] = terraform_output['dark_component']['value']['elb_name']
ENV['dark_asg_name'] = terraform_output['dark_component']['value']['asg_name']
ENV['dark_fqdn'] = terraform_output['dark_component']['value']['fqdn']

ENV['live_elb_hostname'] = terraform_output['live_component']['value']['elb_hostname']
ENV['live_elb_name'] = terraform_output['live_component']['value']['elb_name']
ENV['live_asg_name'] = terraform_output['live_component']['value']['asg_name']
ENV['live_fqdn'] = terraform_output['live_component']['value']['fqdn']

ENV['ping_path'] = terraform_output['ping_path']['value']

RSpec.configure do |config|
  config.after(:suite) do
    terraform_stream_output 'destroy -force'
    `rm -rf ../.terraform`
    `rm -rf ../*.tfstate*`
  end
end


def timeout(timeout, &block)
  interval = 2
  elapsed = 0
  begin
    return block.call
  rescue SocketError => e
    sleep interval
    retry if (elapsed += interval) < timeout
    raise e
  end
end
