module Api
  class BaseController < ActionController::Base
    before_filter :restrict_access
    respond_to :json

    def current_user
      @current_user ||= User.find_by_access_token(@access_token)
    end

    def access_token
      @access_token
    end

    private
    # Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"
    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        @access_token = token
        ApiKey.exists?(access_token: @access_token)
      end
    end
  end
end
