require 'awspec'
require 'json'

def terraform(command)
  Dir.chdir('..') do
    terraform_command = "terraform #{command}"
    puts "$ #{terraform_command}"
    `#{terraform_command}`.strip
  end
end

terraform 'init -force-copy'

terraform 'apply'

terraform_raw_output = terraform 'output -json'

terraform_output = JSON.parse(terraform_raw_output)

ENV['prometheus_elb_hostname'] = terraform_output['prometheus_elb_hostname']['value']
ENV['prometheus_ping_path'] = terraform_output['prometheus_ping_path']['value']

RSpec.configure do |config|
  config.after(:suite) do
    terraform 'destroy -force'
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
