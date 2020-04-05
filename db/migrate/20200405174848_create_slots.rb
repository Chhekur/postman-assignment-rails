class CreateSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :slots do |t|
      t.string :start_time
      t.string :end_time
      t.boolean :is_available
      t.string :day_id

      t.timestamps
    end
  end
end
