class AddImageToEvents < ActiveRecord::Migration
  change_table :events do |t|
    t.references :mercury_image, index: true, foreign_key: true
  end
end
