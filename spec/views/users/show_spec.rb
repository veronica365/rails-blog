require 'rails_helper'

RSpec.describe 'views/users/show.hmtl.erb', type: :view do
  describe 'user show page when user id does not exist' do
    it 'should show a 404 page if id is not a number' do
      visit 'users/fake-user-id'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'There is no details about the specified user')
    end

    it 'should show a 404 page if id is not a number' do
      visit 'users/fake-user-id/posts'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'The specified user has no created blog posts')
    end
    
    it 'should show a 404 page if user id does not even exist' do
      visit 'users/1000'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'There is no details about the specified user')
    end

    it 'should show a 404 page if user id does not exist if viewing posts' do
      visit 'users/1000/posts'
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'The specified user has no created blog posts')
    end
  end

  describe 'user show page when user id does exist' do
    before :each do
      @photo = 'https://source.unsplash.com/random/900x700/?user'
      @name = 'Testing show user'
      @bio = 'Software Developer'
      @user = User.create(name: @name, bio: @bio, photo: @photo)
      visit "users/#{@user.id}"
    end
    
    it 'should see the see the user\'s profile picture.' do
      expect(page).to have_selector('img', count: 1);
      expect(page).to have_css("img[src='#{@photo}']")
    end
    
    it 'should see the user\'s username.' do
      expect(page).to have_selector('h4', count: 1);
      expect(page).to have_css('h4', text: @name)
    end  

    it 'should see the number of posts each user has written.' do
      expect(page).to have_selector('article .body .counter', count: 1);
      expect(page).to have_selector('.counter', text: 'Number of posts: 0')
    end
    
    it 'should see the user\'s bio' do
      expect(page).to have_selector('section.bio .body', count: 1);
      expect(page).to have_selector('section.bio .body b', count: 1);
      expect(page).to have_selector('section.bio .body p', count: 1);
      expect(page).to have_selector('section.bio .body b', text: 'Bio');
      expect(page).to have_selector('section.bio .body p', text: @bio);
    end
    
    it 'should see a related message if user has not posts' do
      expect(page).to have_selector('.body span', count: 1);
      expect(page).to have_selector('.body span', text: 'The user has not added any posts')
    end
    
    it 'should click on a user and be am redirected to that user\'s show page' do
      expect(page).to have_css("a[href='/users/#{@user.id}']")
      
      page.find('a').click
      expect(page).to have_current_path("/users/#{@user.id}");
    end
  end

  describe 'user show page when user has some posts' do
    before :each do
      @photo = 'https://source.unsplash.com/random/900x700/?user'
      @name = 'Testing show user'
      @bio = 'Software Developer'
      @user = User.create(name: @name, bio: @bio, photo: @photo)
    end
    
    it 'should see the user\'s first 3 posts' do
      (1..10).each do |index|
        Post.create(author: @user, title: "title #{index}", text: "This is a blog post #{index}")
      end
      visit "users/#{@user.id}"
      expect(page).to have_selector('article.post .body .counter', count: 3);
      expect(page).to have_selector('.userlist .article .counter', text: "Number of posts: 10");
      expect(page).to have_selector('.links .button-links', text: 'See all posts')
      expect(page).to have_content('Comments: 0, Likes: 0');
    end
    
    it 'should see a button that lets me view all of a user\'s posts' do
      (1..2).each do |index|
        Post.create(author: @user, title: "title #{index}", text: "This is a blog post #{index}")
      end
      visit "users/#{@user.id}"
      expect(page).to have_selector('.links .button-links a', text: 'See all posts')
      expect(page).to have_css(".links .button-links a[href='/users/#{@user.id}/posts']")
    end

    it 'should redirect me to that post\'s show page, when I click a user\'s post' do
      blog = Post.create(author: @user, title: "title test", text: "This is a blog post test")
      
      visit "users/#{@user.id}"
      expect(page).to have_selector('article.post .body .counter', count: 1);
      expect(page).to have_selector('.links .button-links a', text: 'See all posts')
      expect(page).to have_css("section.posts .post a[href='/users/#{@user.id}/posts/#{blog.id}']")
      page.find('section.posts .post a').click
      expect(page).to have_current_path("/users/#{@user.id}/posts/#{blog.id}");
    end
    
    it 'Should redirect me to the user\'s post\'s index page, when I click to see all posts.' do      
      Post.create(author: @user, title: "title test", text: "This is a blog post test")
      visit "users/#{@user.id}"
      expect(page).to have_selector('.links .button-links a', text: 'See all posts')
      page.find('.links .button-links a').click
      expect(page).to have_current_path("/users/#{@user.id}/posts");
    end
  end
end
