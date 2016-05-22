class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :position
      t.string :title
      t.attachment :image
      t.text :content
    end
  end
end
