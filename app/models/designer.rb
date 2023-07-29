class Designer < ActiveRecord::Base
    # Define the one-to-many association between Designer and ProjectProposal
    has_many :project_proposals
  
    # Mount the AvatarUploader to the :avatar column
  mount_uploader :avatar, AvatarUploader
  end