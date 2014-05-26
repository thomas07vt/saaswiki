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

  def wikis_created
    Wiki.where(creator_id: self.id)
  end

  def public_wikis_created
    Wiki.where(creator_id: self.id).where(public: true)
  end

  def private_wikis_created
    Wiki.where(creator_id: self.id).where(public: false)
  end

  def wikis_shared_with_user
    self.wikis
  end

  def recently_active_wikis
    all_wikis = Wiki.where(creator_id: self.id)
    all_wikis.push(*self.wikis.to_a)
    all_wikis.sort_by! {|wiki| wiki.updated_at}
    all_wikis.reverse!
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
