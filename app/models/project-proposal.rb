class ProjectProposal < ActiveRecord::Base
    # Define the one-to-many association between ProjectProposal and Note
    has_many :notes
  
    # Define the many-to-one association between ProjectProposal and Designer
    belongs_to :designer
  
    
  end