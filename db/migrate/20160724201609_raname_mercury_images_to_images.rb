class RanameMercuryImagesToImages < ActiveRecord::Migration
  def change
    rename_table :mercury_images, :images
    rename_column :events, :mercury_image_id, :image_id
  end
end
