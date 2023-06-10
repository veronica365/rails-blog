class Post < ApplicationRecord
  has_many :comments, foreign_key: 'post_id'
  has_many :likes, foreign_key: 'post_id'
  belongs_to :author, class_name: 'User'

  def latest_comments
    comments.order(created_at: :desc).limit(5)
  end

  def increment_post_counts
    author.increment!(:post_counter)
  end
  after_create :increment_post_counts
end
