class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.belongs_to :author, foreign_key: { to_table: :users }, index: true,  null: false
      t.belongs_to :post, foreign_key: { to_table: :posts }, index: true,  null: false

      t.timestamps
    end
  end
end
