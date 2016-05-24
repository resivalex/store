class PageController < Spree::BaseController
  before_action :require_admin, except: :index

  def index
    page = Page.where(name: params[:controller]).take
    @content = page.try(:content) || 'Content'
  end

  def update
    page = Page.find_or_initialize_by(name: params[:controller])
    page.content = params[:content][:page_content][:value]
    page.save

    render nothing: true
  end

private

  def require_admin
    unless current_spree_user.try(:admin?)
      redirect_to '/', alert: 'Access denied'
    end
  end
end