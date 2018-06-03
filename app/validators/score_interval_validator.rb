class ScoreIntervalValidator < ActiveModel::Validator
  def validate(record)
    arel_table = record.class.arel_table
    conds = arel_table[:score_gteq].lt(record.score_lt).and(arel_table[:score_lt].gt(record.score_gteq))
    if record.new_record? && record.class.where(conds).exists?
      record.errors.add :score_interval, '不能有交集'
    end
  end
end