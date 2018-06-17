class AddReferenceToAccoutn < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :user, index:true
  end
end
