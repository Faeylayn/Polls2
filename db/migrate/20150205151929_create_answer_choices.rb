class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.string :answer
      t.integer :q_id


      t.timestamps
    end
    add_index(:answer_choices, :q_id)

  end
end
