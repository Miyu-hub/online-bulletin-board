class AddImgToContributions < ActiveRecord::Migration[6.1]
  def change
    add_column :contributions, :img, :string
  end
end
