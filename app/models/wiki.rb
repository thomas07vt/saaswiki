class Wiki < ActiveRecord::Base
  has_many :assigned_wikis
  has_many :users, :through => :assigned_wikis

  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
end
