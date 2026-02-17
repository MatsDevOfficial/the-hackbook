class WebhooksController < ApplicationController
  allow_unauthenticated_access only: :github
  skip_before_action :verify_authenticity_token

  def github
    # Add logic here to handle specific events later
    # For now, we just acknowledge receipt
    Rails.logger.info "GitHub Webhook Received: #{request.headers['X-GitHub-Event']}"
    
    render json: { message: "Webhook received" }, status: :ok
  end
end
