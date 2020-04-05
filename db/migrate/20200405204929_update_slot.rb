class UpdateSlot < ActiveRecord::Migration[6.0]
  def change
    change_table :slots do |t|
      t.column :user, :string
    end
  end
end
