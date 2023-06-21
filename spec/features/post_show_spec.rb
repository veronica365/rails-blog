require 'rails_helper'

RSpec.describe 'Post show', type: :feature do
  user = User.create(
    name: 'User 2',
    post_counter: 3,
    photo: 'https://cdn-icons-png.flaticon.com/512/21/21104.png',
    bio: 'Project manager'
  )

  post = Post.create(
    author_id: user.id,
    title: 'Post 2',
    text: 'Text for Post 2',
    comments_counter: 2,
    likes_counter: 2
  )

  describe 'Post show page' do
    before { visit user_post_path(user_id: user.id, id: post.id) }

    it 'displays a post\'s title' do
      expect(page).to have_content(post.title)
    end

    it 'displays the user who wrote the post' do
      expect(page).to have_content(user.name)
    end

    it 'displays the number of comments the post has' do
      expect(page).to have_content(post.comments_counter)
    end

    it 'displays the number of likes the post has' do
      expect(page).to have_content(post.likes_counter)
    end

    it 'displays the post\'s body' do
      expect(page).to have_content(post.text)
    end

    it 'displays the username of each commentor' do
      comment = Comment.create(author_id: user.id, post_id: post.id, text: 'I like it')

      visit user_post_path(user.id, post.id)
      expect(page).to have_content(comment.author.name)
    end

    it 'displays the comment each commentor left' do
      comment = Comment.create(author_id: user.id, post_id: post.id, text: 'I like it')

      visit user_post_path(user_id: user.id, id: post.id)
      expect(page).to have_content(comment.text)
    end
  end
end
