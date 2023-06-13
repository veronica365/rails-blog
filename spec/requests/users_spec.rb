require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'Should return the correct response when fetching users' do
      get '/users'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a lists of users')
    end
  end
  describe 'GET /show' do
    it 'Should return the correct response when fetching a user by id' do
      get '/users/:id'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a user by id')
    end
  end
end

RSpec.describe UsersController, type: :controller do
  describe 'GET /users' do
    it 'Should render the correct template' do
      get :index
      expect(response).to render_template('users/index')
    end
  end
  describe 'GET /users/:id' do
    it 'Should render the correct template' do
      get :show, params: { id: '4' }
      expect(response).to render_template('users/show')
    end
  end
end
