class CreateOwner < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|
      t.belongs_to :user, index: true
      t.belongs_to :vehicle, index: true
      t.timestamps
    end
  end
end
