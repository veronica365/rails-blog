class Post < ApplicationRecord
  has_many :comments, foreign_key: 'post_id', dependent: :destroy
  has_many :likes, foreign_key: 'post_id', dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, presence: true, length: { maximum: 250 }
  validates :comments_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :likes_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def latest_comments
    comments.order(created_at: :desc).limit(5)
  end

  def increment_post_counts
    author.increment!(:post_counter)
  end

  def decrement_post_counts
    return unless author.post_counter.positive?

    author.decrement!(:post_counter)
  end

  after_create :increment_post_counts
  before_destroy :decrement_post_counts
end
