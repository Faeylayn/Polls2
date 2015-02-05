class AnswerChoice < ActiveRecord::Base
  validates :answer, :q_id, :presence => true

  belongs_to(:question,
      :class_name => "Question",
      :foreign_key => :q_id,
      :primary_key => :id
  )

  has_many(:responses,
      :class_name => "Response",
      :foreign_key => :answer_id,
      :primary_key => :id
  )



end
