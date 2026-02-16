# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
begin
  Rails.application.initialize!
rescue Exception => e # rubocop:disable Lint/RescueException
  $stderr.puts "[boot:initialize] #{e.class}: #{e.message}"
  raise
end
