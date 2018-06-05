class BaseQuery
  attr_reader :relation

  def initialize(relation)
    @relation = relation
  end

  # def call
  #   ActiveRecord::Base.connection.exec_query(sql).first.to_hash
  # end

  def sql
    to_query.to_sql
  end

  private

  def to_query
    raise NotImplementedError
  end
end