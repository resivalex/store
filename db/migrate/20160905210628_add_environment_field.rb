class AddEnvironmentField < ActiveRecord::Migration
  def change
    add_column :spree_payment_methods, :environment, :string, default: 'production'
  end
end
