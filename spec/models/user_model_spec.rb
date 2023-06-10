require 'rails_helper'

RSpec.describe User, type: :model do
  before(:context) do
    @user = User.create(name: 'Test User 1', bio: 'Software Developer',
                        photo: 'https://source.unsplash.com/random/900x700/?user')
  end

  it 'should always have a name' do
    @user.name = nil
    expect(@user).to_not be_valid

    user = User.create(name: nil, bio: 'Software Developer',
                       photo: 'https://source.unsplash.com/random/900x700/?user')
    expect(user).to_not be_valid
  end

  it 'should have post counter as an interger or a value greater or equal to 0' do
    @user.post_counter = 'z'
    expect(@user).to_not be_valid
    @user.post_counter = -1
    expect(@user).to_not be_valid
  end

  it 'should have lates blog posts count as 3' do
    (1..100).each do |index|
      Post.create(author: @user, title: "title #{index}", text: "This is a blog post #{index}")
    end
    expect(@user.latest_posts.count).to eq(3)
  end
end
