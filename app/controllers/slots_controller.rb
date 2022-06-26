class SlotsController < ApplicationController
  def index
    validation = FindSlotsContract.new.call(params.to_unsafe_hash)

    raise ActionController::BadRequest.new, "The request has failed validation" if validation.failure?
    # binding.pry
    available_slots = AvailableSlotsQuery.new.call(
      date: validation["date"],
      minutes: validation["minutes"]
    )

    render json: available_slots, status: :ok
  end

  def update
    validation = UpdateSlotContract.new.call(uuid: params["id"])

    raise ActionController::BadRequest.new, "The request has failed validation" if validation.failure?

    updated_slot = UpdateSlotCommand.new.call(uuid: validation["uuid"])

    render json: updated_slot, status: :ok
  end
end
