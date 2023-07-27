class CreateProjectProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :project_proposals do |t|
      t.string :title
      t.text :description
      t.belongs_to :designer, foreign_key: true
   
      t.timestamps
    end
  end
end
