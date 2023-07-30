class AddAuthorToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :author, :string
  end
end
