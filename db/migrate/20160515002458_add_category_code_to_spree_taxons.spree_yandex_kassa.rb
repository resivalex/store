# This migration comes from spree_yandex_kassa (originally 20160310090533)
class AddCategoryCodeToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :category_code, :integer
  end
end
