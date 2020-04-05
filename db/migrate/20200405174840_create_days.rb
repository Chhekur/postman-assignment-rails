class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.string :name
      t.string :month_id

      t.timestamps
    end
  end
end
