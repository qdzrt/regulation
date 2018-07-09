class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.admin? || user.director?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.admin? || user.director?
  end

  def update?
    user.admin? || user.director?
  end

  def destroy?
    user.admin? || user.director?
  end

end
