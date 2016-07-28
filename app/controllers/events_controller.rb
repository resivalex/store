class EventsController < Spree::BaseController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end
end
