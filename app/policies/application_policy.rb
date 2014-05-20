class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.present?
  end

  def show?
    scope.where(:id => record.id).exists?
    if (resource.public == true)
      user.present? && scope.where(:id => record.id).exists?
    else
      # Only show private Wiki's to Wiki creator or collaborators
      user.present? && (record.creator == user ||  record.users.where(id: user.id).exists?)
    end
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    # A Wiki can only be updated by the Wiki creator or an editing collaborator.
    user.present? && (record.creator == user ||  record..assigned_wikis.where(user_id: user.id).where(editor: true))
  end

  def edit?
    update?
  end

  def destroy?
    # A Wiki can only be destroyed by its Creator.
    user.present? && record.creator == user
  end

  def scope
    record.class
  end
end

