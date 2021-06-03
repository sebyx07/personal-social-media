class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.references :reaction_counter, null: false, foreign_key: true, index: true
      t.references :peer, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
