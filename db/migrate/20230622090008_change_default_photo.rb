class ChangeDefaultPhoto < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :photo, :string, :default => 'https://source.unsplash.com/random/900x700/?user'
  end
end
