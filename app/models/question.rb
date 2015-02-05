class Question < ActiveRecord::Base
  validates :text, :poll_id, :presence => true

  belongs_to(:poll,
      :class_name => "Poll",
      :foreign_key => :poll_id,
      :primary_key => :id

  )

  has_many(:answer_choices,
      :class_name => "AnswerChoice",
      :foreign_key => :q_id,
      :primary_key => :id
  )

  has_many :responses, :through => :answer_choices, :source => :responses


  def results
    answers = self.answer_choices.includes(:responses)
    results = {}

    answers.each do |answer|
      results[answer.answer] = answer.responses.length
    end

    results
  end

  def results_one_query

    results = self.answer_choices
      .select("answer_choices.*, COUNT(responses.id) AS answer_count")
      .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_id")
      .group("answer_choices.id")

    output = {}

    results.each do |result|
      output[result.answer] = result.answer_count
    end

    output




  end
end
