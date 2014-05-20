class AddEditorToAssignedWikis < ActiveRecord::Migration
  def change
    add_column :assigned_wikis, :editor, :boolean, default: true
  end
end
