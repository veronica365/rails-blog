require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:context) do
    @user = User.create(name: 'Test User 1', bio: 'Software Developer',
                        photo: 'https://source.unsplash.com/random/900x700/?user')
    @blog = Post.create(author: @user, title: 'AI and the future of programming',
                        text: 'Is this the end for developer jobs or the start of a new era')
  end

  it 'should have a title' do
    @blog.title = nil
    expect(@blog).to_not be_valid

    @blog.title = ''
    expect(@blog).to_not be_valid
  end

  it 'shoyld have comments_counter as an integer greater or equal to 0' do
    @blog.comments_counter = 'Invalid value'
    expect(@blog).to_not be_valid

    @blog.comments_counter = 'ten'
    expect(@blog).to_not be_valid

    @blog.comments_counter = 'i'
    expect(@blog).to_not be_valid

    @blog.comments_counter = -1
    expect(@blog).to_not be_valid
  end

  it 'should have likes_counter as an integer greater or equal to zero' do
    @blog.likes_counter = 'five'
    expect(@blog).to_not be_valid

    @blog.likes_counter = -1
    expect(@blog).to_not be_valid
  end

  it 'should update posts counter for user' do
    user = User.create(name: 'Test User 2', bio: 'Software Manager',
                       photo: 'https://source.unsplash.com/random/900x700/?user')
    expect(user.post_counter).to eq(0)

    Post.create(author: user, title: 'AI and the future of programming',
                text: 'Its not true that AI is taking your jobs')
    expect(user.post_counter).to eq(1)
  end

  it 'should have recent comments count as 5' do
    (1..10).each do |index|
      Comment.create(author: @user, text: "This is comment #{index}", post: @blog)
    end
    expect(@blog.latest_comments.count).to eq(5)
  end
end
