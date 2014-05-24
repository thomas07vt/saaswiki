class Collaborator
  include ActiveModel::Model

  attr_accessor :username, :editor

  validates :username, presence: true

  def create(params)
    build_assigned_wiki(params)
  end

  private

  def build_assigned_wiki(params)

    assignedwiki = AssignedWiki.new
    assignedwiki.wiki_id = params[:wiki_id]
    assignedwiki.editor = self.editor || false

    users = User.where(username: self.username)
    if users.any?
      user = users[0]
      assignedwiki.user_id = user.id
    end

    assignedwiki 

  end

end