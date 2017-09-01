require 'json'

MONGO_KEY_PATH = '../mongo-key'


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

`openssl rand -base64 756 > #{MONGO_KEY_PATH}`
`chmod 400 #{MONGO_KEY_PATH}`

terraform_stream_output 'apply'

terraform_raw_output = terraform 'output -json'

terraform_output = JSON.parse(terraform_raw_output)


ENV['ip'] = terraform_output['ip']['value']


RSpec.configure do |config|
  config.after(:suite) do
    terraform_stream_output 'destroy -force'
    `rm -rf ../.terraform`
    `rm -rf #{MONGO_KEY_PATH}`
    `rm -rf ../*.tfstate.backup`
  end
end


def timeout(timeout, &block)
  interval = 5
  elapsed = 0
  begin
    return block.call
  rescue StandardError => e
    sleep interval
    retry if (elapsed += interval) < timeout
    raise e
  end
end
