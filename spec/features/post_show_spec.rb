require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Post, type: :system do
  let(:user) do
    User.create(
      name: 'User 2',
      posts_counter: 3,
      photo: 'https://cdn-icons-png.flaticon.com/512/21/21104.png',
      bio: 'Project manager'
    )
  end

  let(:post) do
    Post.create(
      author_id: user.id,
      title: 'Post 2',
      text: 'Text for Post 2',
      comments_counter: 2,
      likes_counter: 2
    )
  end

  before { post.save }

  describe 'Post show page' do
    it 'displays a post\'s title' do
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(post.title)
    end

    it 'displays the user who wrote the post' do
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(user.name)
    end

    it 'displays the number of comments the post has' do
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(post.comments_counter)
    end

    it 'displays the number of likes the post has' do
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(post.likes_counter)
    end

    it 'displays the post\'s body' do
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(post.text)
    end

    it 'displays the username of each commentor' do
      comment = Comment.new(author_id: user.id, post_id: post.id, text: 'I like it')
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(comment.author.name)
    end

    it 'displays the comment each commentor left' do
      comment = Comment.new(author_id: user.id, post_id: post.id, text: 'I like it')
      visit user_post_path(user.id, post.id)
      expect(page).to have_content(comment.text)
    end
  end
end
