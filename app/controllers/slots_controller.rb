# frozen_string_literal: true

class SlotsController < ApplicationController
  def home
  end
  
  def index
    validation = FindSlotsContract.new.call(params.to_unsafe_hash)

    raise ActionController::BadRequest.new, "The request has failed validation" if validation.failure?

    available_slots = AvailableSlotsQuery.new(
      date: validation["date"],
      minutes: validation["minutes"]
    ).call

    render json: available_slots, status: :ok
  end

  def update
    # binding.pry
    validation = UpdateSlotContract.new.call(start_date: params["start_date"], end_date: params["end_date"])

    raise ActionController::BadRequest.new, "The request has failed validation" if validation.failure?

    updated_slot = UpdateSlotCommand.new.call(start_date: validation["start_date"], end_date: validation["end_date"])

    render json: updated_slot, status: :ok
  end
end
