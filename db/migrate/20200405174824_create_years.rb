class CreateYears < ActiveRecord::Migration[6.0]
  def change
    create_table :years do |t|
      t.string :name
      t.string :calendar_id

      t.timestamps
    end
  end
end
