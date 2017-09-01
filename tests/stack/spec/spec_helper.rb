require 'json'

def terraform(command)
  terraform_command = "terraform #{command}"
  puts "$ #{terraform_command}"
  `#{terraform_command}`.strip
end

Dir.chdir('..')
puts `./toggle-service-with-mongo.sh`
Dir.chdir('toggles') do
  terraform_toggle_raw_output = terraform "output -json"
  terraform_output = JSON.parse(terraform_toggle_raw_output)

  ENV['dark_fqdn'] = terraform_output['dark_component']['value']['fqdn']
  ENV['live_fqdn'] = terraform_output['live_component']['value']['fqdn']
  ENV['ping_path'] = terraform_output['ping_path']['value']
end

RSpec.configure do |config|
  config.after(:suite) do
    puts `./cleanup.sh`
  end
end
