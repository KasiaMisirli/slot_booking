class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.string :uuid
      t.string :start_date_time
      t.string :end_date_time
      t.boolean :is_booked

      t.timestamps
    end
  end
end
