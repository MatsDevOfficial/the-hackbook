# frozen_string_literal: true

Rails.application.configure do
  config.mission_control.jobs.http_basic_auth_enabled = false if config.respond_to?(:mission_control)
end
