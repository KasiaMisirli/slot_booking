# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

january_days = Array(1...32)

january_days.each do |day|
  hours = Array(0...24)
  hours.each do |value|
    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 1, day, value, 0, 0),
      end_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 15.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 15.minutes,
      end_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 30.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 30.minutes,
      end_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 45.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 1, day, value, 0, 0) + 45.minutes,
      end_date_time: DateTime.new(2022, 1, day, value + 1, 0, 0),
      is_booked: false)
  end
end

february_days = Array(1...29)
february_days.each do |day|
  hours = Array(0...24)
  hours.each do |value|
    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 2, day, value, 0, 0),
      end_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 15.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 15.minutes,
      end_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 30.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 30.minutes,
      end_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 45.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 2, day, value, 0, 0) + 45.minutes,
      end_date_time: DateTime.new(2022, 2, day, value + 1, 0, 0),
      is_booked: false)
  end
end

# I have modified time slot 9e323a9e-adf9-605f-9386-c939a9a6af3f and 5117e557-8d86-4180-9326-1ce0cf733982 to reach full slot time.
# I also changed the timezone indication form .000Z" to +00:00
# Will modify program to avoid this modification if I have spare time.
modified_data = [
  {id: "bd8fc476-ac50-3327-4ece-d73897796852", start: "2022-02-01T20:00:00+00:00", end: "2022-02-01T22:30:00+00:00"},
  {id: "8c73d0ca-d999-4081-1558-e5ee6a40fcc2", start: "2022-01-31T23:00:00+00:00", end: "2022-02-01T06:00:00+00:00"},
  {id: "086e3a96-2c74-3d2a-e839-ad10c82626d5", start: "2022-02-01T10:15:00+00:00", end: "2022-02-01T10:45:00+00:00"},
  {id: "9e323a9e-adf9-605f-9386-c939a9a6af3f", start: "2022-02-01T14:00:00+00:00", end: "2022-02-01T14:30:00+00:00"},
  {id: "0510de47-c86e-a64c-bb86-461c039b1012", start: "2022-02-02T10:00:00+00:00", end: "2022-02-02T20:00:00+00:00"},
  {id: "4b24e6ab-bdc6-6b2c-e405-a8e01f0fde84", start: "2022-02-01T09:00:00+00:00", end: "2022-02-01T10:00:00+00:00"},
  {id: "087ddebe-dd41-7e39-bda8-f617d8c4385d", start: "2022-02-01T11:30:00+00:00", end: "2022-02-01T13:00:00+00:00"},
  {id: "5117e557-8d86-4180-9326-1ce0cf733982", start: "2022-02-01T13:00:00+00:00", end: "2022-02-01T13:15:00+00:00"}
]

modified_data.each do |duration_slot|
  all_slots = Slot.all.where("start_date_time  >= ?", duration_slot[:start]).where("end_date_time  <= ?", duration_slot[:end])

  all_slots.map do |slot|
    slot.is_booked = true
    slot.booking_id = duration_slot[:id]
    slot.save!
  end
end
