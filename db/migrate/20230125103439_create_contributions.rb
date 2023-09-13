class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :contributions do |t|
      t.string :name
      t.string :body
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
    end
  end
end
