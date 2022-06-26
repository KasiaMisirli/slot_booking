# "SELECT \"slots\".* FROM \"slots\"
# WHERE \"slots\".\"is_booked\" = 0
# AND (start_date_time  > '2022-06-23 18:24:04.089038')"
# Date above on line 3 is an example of the current time.

class AvailableSlotsQuery
  # Possible impovement: if we want to add user validation, we could add a query handler and keep the query as dry types check only.
  # We could also add repository to keep all the db queries in one place.
  def call(**args)
    requested_day = Date.parse(args[:date])
    following_day = requested_day + 1.day
    # Requesting the following day in case a time slot starts on the requested day and finish on the following day.
    slots_requested_day = Slot.all.where("start_date_time  >= ?", args[:date]).where("start_date_time < ?", following_day)

    raise ActiveRecord::RecordNotFound, "No available slots where found!" if slots_requested_day.nil?

    following_day_slots = Slot.all.where("start_date_time  > ?", following_day).where("start_date_time < ?", following_day + 1.day)

    both_days_slots = slots_requested_day + following_day_slots

    durations_prefered = args[:minutes]
    num_of_slots_needed = (durations_prefered / 15.to_f).ceil # Rounding up to serve a window of multiples of 15 minutes

    available_durations = []

    both_days_slots.each_with_index do |slot, index|
      # never start creating a duration slot on the following day
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
        end_time = DateTime.parse(slot.start_date_time) + (num_of_slots_needed * 15).minutes
        available_durations.push({start_time: slot.start_date_time, end_time: end_time})
      end
    end

    available_durations
  end
end
