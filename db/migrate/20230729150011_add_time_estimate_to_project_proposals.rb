class AddTimeEstimateToProjectProposals < ActiveRecord::Migration[6.1]
  def change
    add_column :project_proposals, :time_estimate, :string
  end
end
