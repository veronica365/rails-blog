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

    it 'should show how many comments it has' do
      post = Post.create(title: 'writer', text: 'written by', author: @user)
      Comment.create(author: @user, post: post, text: 'Test comment')

      visit user_post_path(user_id: @user.id, id: post.id)
      expect(page).to have_css('.posts .comment .body', count: 1)
      expect(page).to have_css('.posts .comment .body', text: 'Test comment')
      expect(page).to have_css('.detail .post span:last-child', text: 'Comments: 1, Likes: 0')
    end

    it 'should show how many likes it has' do
      post = Post.create(title: 'writer', text: 'written by', author: @user)
      Like.create(author_id: @user.id, post_id: post.id)

      visit user_post_path(user_id: @user.id, id: post.id)
      expect(page).to have_css('.posts .comment .body', count: 1)
      expect(page).to have_css('.detail .post span:last-child', text: 'Comments: 0, Likes: 1')
    end

    it 'should show the post body' do
      body = (0..500).to_a
      post = Post.create(author: @user, title: 'test text 100', text: body)

      visit user_post_path(user_id: @user.id, id: post.id)
      expect(page).to have_css('.detail .post p', count: 1)
      expect(page).to have_css('.detail .post p', text: body)
    end

    it 'should show the username of each commentor' do
      user = User.create(name: 'Post commenter', photo: 'https://github.com/avator1.png', bio: 'Dev')
      post = Post.create(title: 'writer', text: 'written by', author: user)
      Comment.create(author: user, post: post, text: 'Testing commenter')

      visit user_post_path(user_id: user.id, id: post.id)
      expect(page).to have_css('.posts .comment .body', count: 1)
      expect(page).to have_css('.posts .comment .body', text: user.name)
    end

    it 'should show the comment each commentor left.' do
      user = User.create(name: 'Post commenter 2', photo: 'https://github.com/avator1.png', bio: 'Dev')
      post = Post.create(title: 'writer', text: 'written by', author: user)
      Comment.create(author: user, post: post, text: 'Testing comment')

      visit user_post_path(user_id: user.id, id: post.id)
      expect(page).to have_css('.posts .comment .body', count: 1)
      expect(page).to have_css('.posts .comment .body', text: ': Testing comment')
    end
  end
end
