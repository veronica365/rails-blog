require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Post', type: :system do
  let(:user) do
    User.create(
      name: 'Test User 1',
      bio: 'Software Developer',
      photo: 'https://source.unsplash.com/random/900x700/?user'
    )
  end

  let(:post) do
    Post.create(
      author: user,
      title: 'AI and the future of programming',
      text: 'Is this the end for developer jobs or the start of a new era'
    )
  end

  before { post }

  describe 'Post index page' do
    before { visit user_posts_path(user_id: user.id) }

    it "displays the user's profile picture" do
      expect(page).to have_css('img')
    end

    it "displays the user's username" do
      expect(page).to have_content(user.name)
    end

    it "displays the number of posts the user has written" do
      expect(page).to have_content(user.posts_counter)
    end

    it "displays a post's title" do
      expect(page).to have_content(post.title)
    end

    it "displays some of the post's body" do
      expect(page).to have_content(post.text)
    end

    it "displays the first comments on a post" do
      comment = Comment.create(author_id: user.id, post_id: post.id, text: 'I like it')
      expect(page).to have_content(comment.text)
    end

    it "displays the number of comments a post has" do
      expect(page).to have_content(post.comments_counter)
    end

    it "displays the number of likes a post has" do
      expect(page).to have_content(post.likes_counter)
    end

    it "redirects to the post's show page when clicked" do
      click_on post.title
      expect(current_path).to eq(user_post_path(user.id, post.id))
    end
  end
end
