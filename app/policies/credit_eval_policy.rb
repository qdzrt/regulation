class CreditEvalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.admin? || user.director?
  end

  def create?
    user.director?
  end

  def update?
    user.director?
  end

  def destroy?
    user.director?
  end

end
