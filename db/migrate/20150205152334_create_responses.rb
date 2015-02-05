class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :answer_id
      t.integer :responder_id

      t.timestamps
    end

    add_index(:responses, :answer_id)
    add_index(:responses, :responder_id)
  end
end
