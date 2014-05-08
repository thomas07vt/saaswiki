class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.integer :creator_id

      t.timestamps
    end
    add_index :wikis, :creator_id
  end
end
