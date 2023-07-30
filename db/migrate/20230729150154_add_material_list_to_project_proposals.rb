class AddMaterialListToProjectProposals < ActiveRecord::Migration[6.1]
  def change
    add_column :project_proposals, :material_list, :text
  end
end
