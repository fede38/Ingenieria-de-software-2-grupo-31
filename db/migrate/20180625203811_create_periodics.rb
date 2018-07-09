class CreatePeriodics < ActiveRecord::Migration[5.0]
  def change
    create_table :periodics do |t|
      t.date :fecha
      t.timestamps
    end
  end
end
