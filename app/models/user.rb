class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, :uniqueness => { :case_sensitive => false }, length: { minimum: 3}, presence: true

  has_many :assigned_wikis
  has_many :wikis, :through => :assigned_wikis

  has_many :created_wiki, :class_name => "Wiki", :foreign_key => :creator_id

  def role?(base_role)
    role == base_role.to_s
  end


  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end


end
