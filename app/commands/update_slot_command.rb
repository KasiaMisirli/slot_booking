# frozen_string_literal: true

class UpdateSlotCommand
  def call(start_date:, end_date:)
    selected_slots = find_selected_slots(start_date: start_date, end_date: end_date)

    raise ActiveRecord::RecordNotFound, "Slots were not found!" if selected_slots.empty?

    update_selected_slots(selected_slots)

    selected_slots
  end

  private

  def find_selected_slots(start_date:, end_date:)
      Slot.all.where(is_booked: false).where("start_date_time  >= ?", start_date).where("end_date_time  <= ?", end_date)
  end

  def update_selected_slots(selected_slots)
    booking_id = SecureRandom.uuid

    selected_slots.map do |slot|
      slot.is_booked = true
      slot.booking_id = booking_id
      slot.save!
    end
  end
end
