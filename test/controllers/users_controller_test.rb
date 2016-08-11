require 'test_helper'

describe UsersController do
  let(:user) { create :user }

  describe '#show' do
    it 'redirects for unauthenticated user' do
      get 'show', {id: user.id}
      assert_response :redirect
    end

    it 'signs the user in' do
      sign_in user
      get 'show', {id: user.id}
      assert_response :success
    end
  end
end
