class CreateDesigners < ActiveRecord::Migration[6.1]
  def change
    create_table :designers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :status 
      t.timestamps
    end
  end
end
