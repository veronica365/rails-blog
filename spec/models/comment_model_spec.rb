require 'rails_helper'

describe Comment, type: :model do
  before(:context) do
    @first_user = User.new(name: 'Test User 1', bio: 'Software Developer',
                           photo: 'https://source.unsplash.com/random/900x700/?user')
    @post = Post.new(author: @first_user, title: 'Programming', text: 'Is such a beauty')
  end

  it 'Should have post comments as o when a post is created' do
    expect(@post.comments_counter).to eq 0
  end

  it 'Should be able to update the post comments counter after a new comment is created ' do
    comment = Comment.create(author: @first_user, post: @post, text: 'First comment')
    expect(@post.comments_counter).to eq 1
    expect(comment.author_id).to eq @first_user.id
  end
end
