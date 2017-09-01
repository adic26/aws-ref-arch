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


ENV['concourse_dns'] = terraform_output['concourse_fqdn']['value']
ENV['concourse_instance_id'] = terraform_output['concourse_instance_id']['value']
ENV['concourse_db_id'] = terraform_output['concourse_db_id']['value']

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
  rescue => e
    sleep interval
    retry if (elapsed += interval) < timeout
    raise e
  end
end
