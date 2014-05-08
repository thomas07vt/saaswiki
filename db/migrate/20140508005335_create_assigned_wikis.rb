class CreateAssignedWikis < ActiveRecord::Migration
  def change
    create_table :assigned_wikis do |t|
      t.integer :user_id
      t.integer :wiki_id

      t.timestamps
    end
  end
end
