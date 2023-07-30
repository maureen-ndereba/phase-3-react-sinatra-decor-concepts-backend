class AddMessageToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :message, :text
  end
end
