require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    it 'Should return the correct response when fetching a user\'s posts' do
      get '/users/:user_id/posts'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a lists of posts for a given user id')
    end
  end
  describe 'GET /show' do
    it 'Should return the correct response when fetching a post by id' do
      get '/users/:user_id/posts/:id'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a post by id for the given user id')
    end
  end
end

RSpec.describe PostsController, type: :controller do
  describe 'GET /users/:user_id/posts' do
    it 'Should render the correct template' do
      get :index, params: { user_id: '12' }
      expect(response).to render_template('posts/index')
    end
  end
  describe 'GET /users/:user_id/posts/:id' do
    it 'Should render the correct template' do
      get :show, params: { user_id: '12', id: '4' }
      expect(response).to render_template('posts/show')
    end
  end
end
