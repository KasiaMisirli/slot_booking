class SlotsController < ApplicationController
  def index
    @available_slots = Slot.all.where(is_booked: false).where("start_date_time  > ?", Time.now)
    render json: @available_slots
  end

  def create
    # POST
    # create a booking/slot booking
  end
end
