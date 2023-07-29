class Note < ActiveRecord::Base
    # Define the many-to-one association between Note and ProjectProposal
    belongs_to :project_proposal
  
    # Define the many-to-one association between Note and Designer
    belongs_to :designer
  
    
  end