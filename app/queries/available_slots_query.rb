# frozen_string_literal: true

class AvailableSlotsQuery
  def initialize(date:, minutes:)
    @date = date
    @minutes = minutes
  end

  def call
    requested_day = Date.parse(date)
    following_day = requested_day + 1.day

    available_durations = []

    both_days_slots = slots_for_duration(requested_day, following_day)

    # Possible imporvement: Break down the below loop into methods
    both_days_slots.each_with_index do |slot, index|
      if Date.parse(slot.start_date_time) != requested_day
        break
      end

      if slot.is_booked?
        next
      end

      entire_duration_available = true

      i = 1
      (num_of_slots_needed - 1).times do
        if both_days_slots[index + i].is_booked?

          entire_duration_available = false
        end
        i += 1
      rescue
        entire_duration_available = false
        break
      end

      if entire_duration_available == true
        assemble_duration_slot(slot, num_of_slots_needed, available_durations)
      end
    end

    available_durations
  end

  attr_reader :date, :minutes

  private

  def num_of_slots_needed
    # Rounding up to serve a window of multiples of 15 minutes
    (minutes / 15.to_f).ceil
  end

  def slots_for_duration(requested_day, following_day)
    requested_day_slots = Slot.all.where("start_date_time  >= ?", requested_day).where("start_date_time < ?", following_day)

    raise ActiveRecord::RecordNotFound, "No available slots where found!" if requested_day_slots.nil?

    # Requesting the following day in case a time slot starts on the requested day and finish on the following day.
    following_day_slots = Slot.all.where("start_date_time  >= ?", following_day).where("start_date_time < ?", following_day + 1.day)

    requested_day_slots + following_day_slots
  end

  def assemble_duration_slot(slot, num_of_slots_needed, available_durations)
    end_time = DateTime.parse(slot.start_date_time) + (num_of_slots_needed * 15).minutes
    available_durations.push({start_time: slot.start_date_time, end_time: end_time})
  end
end
