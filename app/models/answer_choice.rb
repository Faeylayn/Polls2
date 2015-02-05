class AnswerChoice < ActiveRecord::Base
  validates :answer, :q_id, :presence => true



end
