class Response < ActiveRecord::Base
  validate :responder_id, :answer_id, :presence => true
  validate :validate_respondent_has_not_already_answered_question
  validate :validate_not_author

  belongs_to(:respondent,
        :class_name => "User",
        :foreign_key => :responder_id,
        :primary_key => :id
  )


  belongs_to(:answer_choice,
        :class_name => "AnswerChoice",
        :foreign_key => :answer_id,
        :primary_key => :id

  )


  has_one :question, :through => :answer_choice, :source => :question

  has_one :poll, :through => :question, :source => :poll


  def sibling_responses
    self.question.responses.where("responses.id != ? OR ? IS NULL", self.id, self.id)
  end

  def validate_respondent_has_not_already_answered_question
    siblings = self.sibling_responses

    siblings.each do |sibling|
      if sibling.responder_id == self.responder_id
        errors[:duplicate] << "cannot answer question again"
      end
    end

  end

  def validate_not_author
    poll = self.question.poll
      if self.responder_id = poll.author_id
        errors[:author] << "cannot answer own questions"
      end
  end

end
