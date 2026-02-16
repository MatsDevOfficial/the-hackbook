# This file is used by Rack-based servers to start the application.

begin
  require_relative "config/environment"
rescue Exception => e # rubocop:disable Lint/RescueException
  $stderr.puts "[boot] #{e.class}: #{e.message}"
  raise
end

run Rails.application
Rails.application.load_server
