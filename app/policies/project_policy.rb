# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return false if record.discarded? && !admin?
    admin? || !record.is_unlisted || member?
  end

  def create?
    user.present?
  end

  def update?
    return false if record.discarded? && !admin?
    admin? || leader?
  end

  def destroy?
    return false if record.discarded?
    admin? || leader?
  end

  private

  def member?
    record.user == user || record.project_memberships.exists?(user: user)
  end

  def leader?
    record.user == user || record.project_memberships.exists?(user: user, role: :leader)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.kept.listed.or(scope.kept.where(user: user))
      end
    end
  end
end
