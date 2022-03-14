class RemoveStoreFromShoe < ActiveRecord::Migration[6.0]
  def change
    remove_column :shoes, :store, :string
  end
end
