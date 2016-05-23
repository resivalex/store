class AddImageSrcToEvents < ActiveRecord::Migration
  def change
    add_column :events, :image_src, :string
  end
end
