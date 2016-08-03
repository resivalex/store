class RemoveLegacyEventAttachment < ActiveRecord::Migration
  def change
    remove_column :events, :image_file_name, :string
    remove_column :events, :image_content_type, :string
    remove_column :events, :image_file_size, :string
    remove_column :events, :image_updated_at, :timestamp
  end
end
