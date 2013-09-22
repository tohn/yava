# ApplicationController
class ApplicationController < ActionController::Base
  # before_action :set_locale
  # before_filter :authenticate

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # http://guides.rubyonrails.org/i18n.html#setting-and-passing-the-locale
  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  helper_method :current_user

  private
    # current_user helper method
    def current_user
      # TODO: Error, if user deletes herself and refreshes the page
      # (user not available anymore -> search results in nil ->
      # error)
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    # Authentication for single user environments
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["USERNAME"] && password == ENV["PASSWORD"]
        session[:user_id] = 1
      end
    end

end
