module Api
  module V1
    class AuthenticationController < BaseController
      skip_before_filter :restrict_access

      def index
        render json: {status: 'pong'}, status: :ok
      end

      def create
        user = User.find_by_email(user_params[:email])
        if user && user.valid_password?(user_params[:password])
          api_key = user.generate_api_key
          render json: {api_key: api_key, user_id: user.id}, status: :ok
        else
          errors = user.blank? ? "Invalid email address" : "Invalid password"
          render json: {errors: errors}, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end

