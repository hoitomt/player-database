module Api
  module V1
    class UsersController < BaseController
      skip_before_filter :restrict_access
      before_action :verify_params_presence

      def create
        user = User.new(user_params)
        if user.save
          api_key = user.generate_api_key
          render json: {api_key: api_key, user_id: user.id}, status: :ok
        else
          render json: {error: user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private
      def verify_params_presence
        head(:bad_request) if params[:user].blank?
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end
    end
  end
end
