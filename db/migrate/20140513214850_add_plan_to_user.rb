class AddPlanToUser < ActiveRecord::Migration
  def change
    add_column :users, :plan, :integer
  end
end
