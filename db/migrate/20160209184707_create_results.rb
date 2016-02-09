class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :name
      t.integer :likes

      t.timestamps null: false
    end
  end
end
