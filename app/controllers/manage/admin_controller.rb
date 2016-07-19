class Manage::ApplicationController < Spree::BaseController
  before_action :require_admin

  private

  def require_admin
    unless current_spree_user.try(:admin?)
      redirect_to '/', alert: 'Access denied'
    end
  end
end
