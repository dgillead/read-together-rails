class CreateBookDiscussions < ActiveRecord::Migration[5.1]
  def change
    create_table :book_discussions do |t|
      t.integer :user_id, null: false
      t.string :book_title, null: false
      t.string :book_url, null: false
      t.string :book_image_url, null: false
      t.text :discussion_participants, array: true, default: []
      t.timestamps
    end
  end
end
