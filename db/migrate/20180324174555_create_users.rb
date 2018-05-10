class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :instagram
      t.string :twitter
      t.string :facebook
      t.string :github

      t.timestamps
    end
  end
end
