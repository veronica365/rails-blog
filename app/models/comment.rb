class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :post, class_name: 'Post', foreign_key: 'post_id'

  def increment_comment_counters
    post.increment!(:comments_counter)
  end

  after_create :increment_comment_counters
end
