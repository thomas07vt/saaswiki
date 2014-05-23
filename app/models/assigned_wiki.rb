class AssignedWiki < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates :user_id, presence: true
  validates :wiki_id, presence: true
  validates_uniqueness_of :user_id, scope: :wiki_id
  
end
