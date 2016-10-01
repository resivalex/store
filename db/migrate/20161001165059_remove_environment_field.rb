class RemoveEnvironmentField < ActiveRecord::Migration
  def change
    remove_column :spree_payment_methods, :environment, :string, default: 'production'
  end
end
