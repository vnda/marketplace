class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def store
    @store ||= Store.find_by!(token: params[:token])
  end

  def authenticate!
    if Rails.env == "production"
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["HTTP_USER"] && password == ENV["HTTP_PASSWORD"]
      end
    end
  end
end
