class Collaborator
  include ActiveModel::Model

  attr_accessor :username, :editor

  validates :username, presence: true

  def create(params)
    build_assigned_wiki(params)
  end

  private

  def build_assigned_wiki(params)
    collaborator = {}
    assignedwiki = AssignedWiki.new
    assignedwiki.wiki_id = params[:wiki_id]
    assignedwiki.editor = self.editor || false
    wiki = Wiki.find(params[:wiki_id])

    users = User.where(username: self.username)
    if users.any?
      user = users[0]
      if user.id != wiki.creator.id
        assignedwiki.user_id = user.id
      else
        collaborator[:error] = "The Wiki creator is already a collaborator."
      end

    else
      collaborator[:error] = "There is no '#{self.username}' username."
    end
    collaborator[:assigned_wiki] = assignedwiki
    collaborator

  end

end