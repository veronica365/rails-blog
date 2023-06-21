require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    it "should return the correct response when fetching a user's posts" do
      get user_posts_path(user_id: ':user_id')
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a list of posts for a given user id')
    end
  end

  describe 'GET /show' do
    it 'should return the correct response when fetching a post by id' do
      get user_post_path(user_id: ':user_id', id: ':id')
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Here is a post by id for the given user id')
    end
  end
end

RSpec.describe PostsController, type: :controller do
  describe 'GET /users/:user_id/posts' do
    it 'should render the correct template' do
      get :index, params: { user_id: '12' }
      expect(response).to render_template('posts/index')
    end
  end

  describe 'GET /users/:user_id/posts/:id' do
    it 'should render the correct template' do
      get :show, params: { user_id: '12', id: '4' }
      expect(response).to render_template('posts/show')
    end
  end
end
