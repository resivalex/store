class EventsController < Spree::BaseController
  before_filter :require_admin, except: [:index, :show]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end
end