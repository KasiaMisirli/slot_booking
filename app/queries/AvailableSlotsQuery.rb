# "SELECT \"slots\".* FROM \"slots\"
# WHERE \"slots\".\"is_booked\" = 0
# AND (start_date_time  > '2022-06-23 18:24:04.089038')"
# Date above on line 3 is an example of the current time.

class AvailableSlotsQuery
  # Possible impovement: if we want to add user validation, we could add a query handler and keep the query as dry types check only.
  # We could also add repository to keep all the db queries in one place.
  def call
    Slot.all.where(is_booked: false).where("start_date_time  > ?", Time.zone.now)
  end
end
