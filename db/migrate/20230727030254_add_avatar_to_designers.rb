class AddAvatarToDesigners < ActiveRecord::Migration[6.1]
  def change
    add_column :designers, :avatar, :string
  end
end
