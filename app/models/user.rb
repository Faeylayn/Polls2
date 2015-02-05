class User < ActiveRecord::Base
  validates :user_name, :presence => true
  validates :user_name, :uniqueness => true

  has_many(:polls,
      :class_name => "Poll",
      :foreign_key => :author_id,
      :primary_key => :id
  )

  has_many(:responses,
      :class_name => "Response",
      :foreign_key => :responder_id,
      :primary_key => :id
  )


  def completed_polls
    output = []

    polls = self.polls.includes(:questions, :responses)

    polls.each do |poll|
      completed = true
      poll.questions.each do |question|
        unless question.responses.exists?(:responder_id => self.id)
          completed = false
          break
        end
      end
      output << poll if completed
    end
    output
  end

  def completed_polls_less


    # results = Poll.select("polls.*, count(q1.id) AS answered_questions, count(q2.id) AS total_questions")
    # .joins("questions q1 ON polls.id = q1.poll_id")
    # .joins("answer_choices a ON q1.id = a.q_id")
    # .joins("LEFT OUTER JOIN responses r ON a.id = r.answer_id")
    # .joins("questions q2 ON polls.id = q2.poll_id")
    # .where("r.responder_id = ?", self.id)
    # .group("polls.id")
    output = []
    results = Poll.find_by_sql([<<-SQL, self.id])

    SELECT
      polls.*, count(DISTINCT(q1.id)) AS answered_questions
    FROM
      polls
    JOIN
      questions q1 ON polls.id = q1.poll_id
    JOIN
      answer_choices a ON q1.id = a.q_id
    LEFT OUTER JOIN
      responses r ON a.id = r.answer_id
    WHERE
      r.responder_id = ?
    GROUP BY
      polls.id

    SQL

    results.each do |result|
      output << result if result.answered_questions == result.questions.length
    end
    output
  end


end
