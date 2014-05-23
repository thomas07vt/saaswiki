class WikiPolicy < ApplicationPolicy

  def destroy?
    # A Wiki can only be destroyed by its Creator.
    access?
  end

  def access?
    # Only a Wiki creator can decide who has read/write access to the Wiki.
    user.present? && record.creator == user
  end

  def show?
    if (record.public == true)
      user.present? && scope.where(:id => record.id).exists?
    else
      # Only show private Wiki's to Wiki creator or collaborators
      user.present? && (record.creator == user ||  record.users.where(id: user.id).exists?) && scope.where(:id => record.id).exists?
    end
  end

  def create?
    # A user must not have a free account to create private wiki's
    if (record.public == true)
      user.present?
    else
      user.present? && !user.role?(:basic)
    end
  end

  def new?
    create?
  end

end