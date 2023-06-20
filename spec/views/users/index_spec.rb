require 'rails_helper'

RSpec.describe 'views/users/index.hmtl.erb', type: :view do
  describe 'user index page when there are no users' do
    before :context do
      Like.delete_all()
      Comment.delete_all()
      Post.delete_all()
      User.delete_all()
      visit 'users'
    end

    it 'should show a 404 page if there are no users' do
      expect(page).to have_css('h1', text: 'Not found')
      expect(page).to have_css('span', text: 'There are no registered users at the moment')
    end
  end

  describe 'user index page when there are users' do
    before :each do
      @photo = 'https://source.unsplash.com/random/900x700/?user'
      @name = 'Testing user'
      @bio = 'Software Developer'
      @user = User.create(name: @name, bio: @bio, photo: @photo)
      visit 'users'
    end

    it 'should see the username of all other users' do
      expect(page).to have_selector('h4', count: 1);
      expect(page).to have_css('h4', text: @name)
    end

    it 'should see the profile picture for each user.' do
      expect(page).to have_selector('img', count: 1);
      expect(page).to have_css("img[src='#{@photo}']")
    end

    it 'should see the number of posts each user has written.' do
      expect(page).to have_selector('article .body .counter', count: 1);
      expect(page).to have_selector('.counter', text: 'Number of posts: 0')
    end

    it 'should click on a user and be am redirected to that user\'s show page' do
      expect(page).to have_css("a[href='/users/#{@user.id}']")

      page.find('a').click
      expect(page).to have_current_path("/users/#{@user.id}");
    end
  end

  describe 'Number of posts when user has a post' do
    before :each do
      @photo = 'https://source.unsplash.com/random/900x700/?user'
      @name = 'Testing user'
      @bio = 'Software Developer'
      @user = User.create(name: @name, bio: @bio, photo: @photo)
    end

    it 'should see the number of posts each user has written.' do
      Post.create(author: @user, title: 'AI and the future of programming',
                  text: 'Is this the end for developer jobs or the start of a new era')
      visit 'users'
      expect(page).to have_selector('article .body .counter', count: 1);
      expect(page).to have_selector('.counter', text: 'Number of posts: 1')
    end
  end
end
