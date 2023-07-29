require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'mini_magick'

class AvatarUploader < CarrierWave::Uploader::Base
    #Storage provider
    storage :file
  
    # Set the directory where uploaded files will be stored (relative to the public folder)
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  
    # Add image processing with mini_magick (e.g., resizing)
    process resize_to_fit: [200, 200]
  
    # Set allowed file extensions
    def extension_allowlist
      %w[jpg jpeg png]
    end
  
    # Default image to use if no avatar is uploaded
     def default_url(*args)
      '/images/default_avatar.png'
    end
  ends