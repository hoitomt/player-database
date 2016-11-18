require 'rails_helper'

describe Api::V1::TeamsController do
  let(:user) { create :user}

  describe 'invalid token' do
    it 'returns a 401' do
      get :index
      assert_response :unauthorized
    end
  end
end
