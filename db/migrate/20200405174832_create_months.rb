class CreateMonths < ActiveRecord::Migration[6.0]
  def change
    create_table :months do |t|
      t.string :name
      t.string :year_id

      t.timestamps
    end
  end
end
