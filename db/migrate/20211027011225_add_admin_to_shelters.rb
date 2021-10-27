class AddAdminToShelters < ActiveRecord::Migration[5.2]
  def change
    add_reference :shelters, :admin, foreign_key: true
  end
end
