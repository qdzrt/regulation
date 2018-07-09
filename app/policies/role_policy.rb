class RolePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
