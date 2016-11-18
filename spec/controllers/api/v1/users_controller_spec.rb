require 'rails_helper'

describe Api::V1::UsersController do

  describe 'POST create' do
    describe 'valid params' do
      let(:params) {
        {
          first_name: 'Homer',
          last_name: 'Simpson',
          email: 'homer@springfield.com',
          password: 'Nuclear7'
        }
      }

      it 'responds successfully' do
        post :create, {user: params}
        assert_response :success
      end

      it 'creates a new user' do
        expect {
          post :create, {user: params}
        }.to change{User.count}.by(1)
      end

      it 'responds with an api_key' do
        post :create, {user: params}
        expect(JSON.parse(response.body)['api_key']).to_not be_nil
        expect(JSON.parse(response.body)['user_id']).to_not be_nil
      end
    end

    describe 'invalid params' do
      it 'empty' do
        post :create
        assert_response :bad_request
      end

      it 'missing email' do
        post :create, {user: {password: 'bartL!sa'}}
        assert_response :unprocessable_entity
      end

      it 'missing password' do
        post :create, {user: {email: 'test@example.com'}}
        assert_response :unprocessable_entity
      end

      it 'invalid email' do
        post :create, {user: {email: 'example.com', password: 'bartL!sa'}}
        assert_response :unprocessable_entity
      end
    end
  end

end
