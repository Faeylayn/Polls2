class Response < ActiveRecord::Base
  validate :responder_id, :answer_id, :presence => true
  validate :validate_respondent_has_not_already_answered_question
  #validate :validate_not_author
  validate :does_not_respond_to_own_poll

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


  # def sibling_responses
  #   self.question.responses.where("responses.id != ? OR ? IS NULL", self.id, self.id)
  # end

  def sibling_responses
    AnswerChoices.select("responses.*")
    .joins("INNER JOIN questions q1 ON q1.id = answer_choices.q_id")
    .joins("INNER JOIN answer_choices ac1 ON ac1.q_id = q1.id")
    .joins("INNER JOIN responses ON responses.answer_id = ac1.id")
    .where("ac1.id = ?", self.answer_id)
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
    if self.responder_id == poll.author_id
      errors[:author] << "cannot answer own questions"
    end
  end

  def does_not_respond_to_own_poll
    poll = Poll.select("polls.*")
    .joins("INNER JOIN questions ON questions.poll_id = polls.id")
    .joins("INNER JOIN answer_choices ON questions.id = answer_choices.q_id")
    .where("answer_choices.id = ?", self.answer_id)

    if self.responder_id == poll.first.author_id
      errors[:author] << "cannot answer own questions"
    end
  end

end
