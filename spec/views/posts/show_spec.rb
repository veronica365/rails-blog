require 'rails_helper'

RSpec.describe 'views/posts/show.hmtl.erb', type: :view do
  describe 'posts show page when the post does not exist' do
    it 'should show a 404 page if id is not a number' do
      visit 'users/fake-user-id/posts/unknown-id'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'There blog post specified by user does not exist')
    end
    it 'should show a 404 page if id is not a number' do
      visit 'users/10000/posts/10000'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'There blog post specified by user does not exist')
    end
  end

  describe 'posts show page when the post does exist' do
    before :each do
      @user = User.create(name: 'User 1', photo: 'https://github.com/avator1.png', bio: 'Dev')
      visit user_posts_path(@user)
    end
    it 'should show a post\'s title' do
      post = Post.create(title: 'title', text: 'text', author: @user)
      visit user_post_path(user_id: @user.id, id: post.id)
      expect(page).to have_content(post.title)
      expect(page.find('.detail .post span:first-child')).to have_content(post.title)
      expect(page).to have_css('.detail .post span:first-child', text: "#{post.title} by #{@user.name}")
    end

    it 'should show who wrote the post' do
      post = Post.create(title: 'writer', text: 'written by', author: @user)
      visit user_post_path(user_id: @user.id, id: post.id)
      expect(page.find('.detail .post span:first-child')).to have_content(@user.name)
      expect(page).to have_css('.detail .post span:first-child', text: "#{post.title} by #{@user.name}")
    end
  end
end
