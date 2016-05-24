class MyMercuryController < MercuryController
  before_filter :admin_required

private
  def admin_required
    unless current_spree_user.try(:admin?)
      redirect_to '/', alert: 'Access denied'
    end
  end
end