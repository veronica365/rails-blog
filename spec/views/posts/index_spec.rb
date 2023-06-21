require 'rails_helper'

RSpec.describe 'views/posts/index.hmtl.erb', type: :view do
  describe 'posts index page when the post does not exist' do
    it 'should show a 404 page if id is not a number' do
      visit 'users/fake-user-id/posts'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'The specified user has no created blog posts')
    end
  end

  describe 'posts index page when the posts do' do
    before :each do
      @user = User.create(name: 'User 1', photo: 'https://github.com/avator1.png', bio: 'Dev')
      visit user_posts_path(@user)
    end

    it 'should see the user\'s profile picture.' do
      expect(page).to have_css("img[src='#{@user.photo}']")
      expect(page).to have_selector('section.userlist .article', count: 1)
      expect(page).to have_css('.justify-content-between h4', text: 'Posts')
      expect(page).to have_css('.justify-content-between a', text: 'Create post')
      expect(page).to have_css("a[href='/users/#{@user.id}/posts/new']")
    end

    it 'should see the user\'s username.' do
      expect(page).to have_selector('section.userlist .article h4', count: 1)
      expect(page).to have_css('section.userlist .article h4', text: @user.name)
    end

    it 'should see the number of posts the user has written. 1' do
      expect(page).to have_selector('section.userlist .article .counter', count: 1)
      expect(page).to have_css('section.userlist .article .counter', text: 'Number of posts: 0')
    end

    it 'should see a post\'s title' do
      Post.create(author: @user, title: 'test title', text: 'test body')

      visit user_posts_path(@user)
      expect(page).to have_selector('section.posts .post .body b', count: 1)
      expect(page).to have_css('section.posts .post .body b', text: 'test title')
    end

    it 'should see some of the post\'s body part one' do
      body = (0..1000).to_a.join('-')
      Post.create(author: @user, title: 'test title', text: body)

      visit user_posts_path(@user)
      expect(page).to have_selector('section.posts .post .body p', count: 1)
      expect(page).to have_css('section.posts .post .body p', text: "#{body[0..157]} ...")
    end

    it 'should see some of the post\'s body part two' do
      body = (0..50).to_a.join('-')
      Post.create(author: @user, title: 'test text 100', text: body)

      visit user_posts_path(@user)
      expect(page).to have_css('section.posts .post .body b', text: 'test text 100')
      expect(page).to have_selector('section.posts .post .body p', count: 1)
      expect(page).to have_css('section.posts .post .body p', text: body)
      expect(page).to have_css('section.posts .post .body p', text: body[0..157])
    end

    it 'should see the first comments on a post.' do
      post = Post.create(author: @user, title: 'test comment', text: 'body')
      comment = Comment.create(author: @user, post: post, text: 'Test comment')

      visit user_posts_path(@user)
      expect(page).to have_css('section.posts .post .body b', text: 'test comment')
      expect(page).to have_css('section.posts .comment .body', count: 1)
      expect(page).to have_css('section.posts .comment .body', text: comment.text)
    end

    it 'should see how many comments a post has.' do
      post = Post.create(author: @user, title: 'test comment', text: 'body')
      Comment.create(author: @user, post: post, text: 'Test comment')

      visit user_posts_path(@user)
      expect(page).to have_css('section.posts .post .body .counter', count: 1)
      expect(page).to have_css('section.posts .post .body .counter', text: 'Comments: 1, Likes: 0')
    end

    it 'should see how many likes a post has' do
      post = Post.create(author: @user, title: 'test comment', text: 'body')
      Like.create(author_id: @user.id, post_id: post.id)

      visit user_posts_path(@user)
      expect(page).to have_css('section.posts .post .body .counter', count: 1)
      expect(page).to have_css('section.posts .post .body .counter', text: 'Comments: 0, Likes: 1')
    end

    it 'should see a section for pagination if there are more posts than fit on the view' do
      Post.create(author: @user, title: 'test comment', text: 'body')

      visit user_posts_path(@user)
      expect(page).to have_selector('.links .button-links', text: 'Pagination')
    end

    it 'should redirect me to that post\'s show page, when I click a user\'s post' do
      blog = Post.create(author: @user, title: 'title test', text: 'This is a blog post test')

      visit user_posts_path(@user)
      expect(page).to have_selector('article.post .body .counter', count: 1)
      expect(page).to have_selector('.links .button-links a', text: 'Pagination')
      expect(page).to have_css("section.posts .post a[href='/users/#{@user.id}/posts/#{blog.id}']")
      page.find('section.posts .post a').click
      expect(page).to have_current_path("/users/#{@user.id}/posts/#{blog.id}")
    end
  end
end
