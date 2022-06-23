class UpdateSlotCommand
  def call(uuid:)
    # Possible impovement: adding a command handler and keep the command as dry types check only.
    # We could also add repository to keep all the db commands in one place.
    slot = Slot.find_by(uuid: uuid)

    raise ActiveRecord::RecordNotFound, "Slot was not found!" if slot.nil?

    slot.is_booked = true
    slot.save!

    slot
  end
end
