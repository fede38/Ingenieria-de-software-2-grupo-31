class CreateRelation < ActiveRecord::Migration[5.0]
  def change
    create_table :user_vehicle, id: false do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :vehicle, index: true
    end
  end
end
