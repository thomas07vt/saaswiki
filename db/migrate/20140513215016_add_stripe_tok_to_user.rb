class AddStripeTokToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_tok, :string
  end
end
