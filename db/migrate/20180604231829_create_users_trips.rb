class CreateUsersTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :users_trips do |t|
      t.belongs_to :users, index: true
      t.belongs_to :trips, index: true
      t.timestamps
    end
  end
end
