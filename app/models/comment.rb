class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :post, class_name: 'Post', foreign_key: 'post_id'

  def increment_comment_counters
    post.increment!(:comments_counter)
  end

  def decrement_comment_counts
    return unless post.comments_counter.positive?

    post.decrement!(:comments_counter)
  end

  after_create :increment_comment_counters
  before_destroy :decrement_comment_counts
end
