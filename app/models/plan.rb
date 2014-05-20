class Plan < ActiveRecord::Base

  validates :name, presence: true
  validates :price, presence: true
  validates :pid, presence: true

  def cost
    ActionController::Base.helpers.number_to_currency(self.price)
  end

end
