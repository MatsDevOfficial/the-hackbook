class AuthController < ApplicationController
  allow_unauthenticated_access only: %i[ new create bypass github ]
  skip_before_action :redirect_banned_user!, only: %i[destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to signin_path, alert: "Try again later." }

  def new
    state = SecureRandom.hex(24)
    session[:state] = state

    Rails.logger.tagged("Authentication") do
      Rails.logger.info({
        event: "oauth_flow_started",
        state: state,
        callback_url: hca_callback_url,
        session_id: session.id.to_s
      }.to_json)
    end

    redirect_to HcaService.authorize_url(hca_callback_url, state), allow_other_host: true
  end

  def bypass
    unless Rails.env.development?
      redirect_to root_path, alert: "Not allowed in production!"
      return
    end

    user = User.find_or_create_by!(email: "619401@olz.nl") do |u|
      u.display_name = "Dev Admin"
      u.avatar = "https://github.com/hackclub.png"
      u.timezone = "UTC"
      u.slack_id = "U_BYPASS"
      u.hca_id = "hca_bypass"
      u.roles = [ "user", "admin" ]
    end

    user.add_role(:admin) unless user.admin?
    session[:user_id] = user.id

    redirect_to root_path, notice: "Logged in as #{user.display_name} (Bypass Mode)"
  end

  def create
    Rails.logger.tagged("Authentication") do
      Rails.logger.info({
        event: "oauth_callback_received",
        has_code: params[:code].present?,
        has_state: params[:state].present?,
        session_state: session[:state],
        params_state: params[:state],
        session_id: session.id.to_s
      }.to_json)
    end

    if params[:state] != session[:state]
      Rails.logger.tagged("Authentication") do
        Rails.logger.error({
          event: "csrf_validation_failed",
          expected_state: session[:state],
          received_state: params[:state]
        }.to_json)
      end
      session[:state] = nil
      redirect_to root_path, alert: "Authentication failed due to CSRF token mismatch"
      return
    end

    begin
      user = User.exchange_hca_token(params[:code], hca_callback_url)
      session[:user_id] = user.id

      Rails.logger.tagged("Authentication") do
        Rails.logger.info({
          event: "authentication_successful",
          user_id: user.id,
          email: user.email,
          session_user_id: session[:user_id],
          session_id: session.id.to_s
        }.to_json)
      end

      redirect_to home_path, notice: "Welcome back, #{user.display_name}!"
    rescue StandardError => e
      Rails.logger.tagged("Authentication") do
        Rails.logger.error({
          event: "authentication_failed",
          error: e.message
        }.to_json)
      end
      redirect_to root_path, alert: e.message
    end
  end

  def github
    # This will be replaced with real GitHub OAuth logic later
    # For now, we stub it to capture the callback
    render plain: "GitHub Callback Received! We will implement state matching and token exchange soon."
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Signed out successfully. Cya!"
  end
end
