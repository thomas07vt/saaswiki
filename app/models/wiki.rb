class Wiki < ActiveRecord::Base
  has_many :assigned_wikis, dependent: :destroy
  has_many :users, :through => :assigned_wikis

  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  validates :title, length: { minimum: 3 }, presence: true
  validates :body, presence: true
end
