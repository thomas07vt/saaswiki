class AssignedWikiPolicy < ApplicationPolicy

  def create?
    user.present? && record.wiki.creator == user
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

end