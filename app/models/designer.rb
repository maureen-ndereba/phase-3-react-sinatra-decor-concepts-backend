
class Designer < ActiveRecord::Base
    # Define the one-to-many association between Designer and ProjectProposal
    has_many :project_proposals
    has_secure_password
  
    # Mount the AvatarUploader to the :avatar column
  mount_uploader :avatar, AvatarUploader
    #Status; Active- works there currently, Pending- still hasn't been employed, Archived- no longer working there)
  enum status: { active: 'active', pending: 'pending', archived: 'archived' }
end
  