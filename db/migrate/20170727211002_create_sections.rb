class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.integer :book_discussion_id, null: false
      t.string :title, null: false
      t.timestamps
    end
  end
end
