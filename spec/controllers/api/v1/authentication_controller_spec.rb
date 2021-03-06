require 'rails_helper'

describe Api::V1::AuthenticationController do
  let!(:user){ create :user }

  describe 'GET index' do
    it 'responds' do
      get :index
      assert_response :success
    end
  end

  describe 'POST create' do
    describe 'valid params' do
      it 'responds successfully' do
        post :create, {user: {email: user.email, password: user.password}}
        assert_response :success
      end

      it 'responds with an api_key' do
        post :create, {user: {email: user.email, password: user.password}}
        expect(JSON.parse(response.body)['api_key']).to eq user.reload.api_key.access_token
        expect(JSON.parse(response.body)['user_id']).to eq user.reload.id
      end
    end
  end
end
