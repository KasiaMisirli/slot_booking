class SlotsController < ApplicationController
  def index
    available_slots = AvailableSlotsQuery.new.call

    render json: available_slots, status: :ok
  end

  def update
    validation = UpdateSlotContract.new.call(uuid: params["id"])

    raise ActionController::BadRequest.new, "The request has failed validation" if validation.failure?

    updated_slot = UpdateSlotCommand.new.call(uuid: validation["uuid"])

    render json: updated_slot, status: :ok
  end
end
