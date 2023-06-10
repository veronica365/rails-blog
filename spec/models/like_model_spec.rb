require 'rails_helper'

describe Like, type: :model do
  before(:context) do
    @user = User.new(name: 'Test User 1', bio: 'Software Developer',
                     photo: 'https://source.unsplash.com/random/900x700/?user')
    @blog = Post.new(author: @user, title: 'AI and the future of programming',
                     text: 'Is this the end for developer jobs or the start of a new era')
  end

  it 'Should have post likes as o when a post is created' do
    expect(@blog.likes_counter).to eq 0
  end

  it 'Should be able to update the post likes counter after a new like is created ' do
    like = Like.create(author: @user, post: @blog)
    expect(@blog.likes_counter).to eq 1
    expect(like.author_id).to eq @user.id
  end
end
