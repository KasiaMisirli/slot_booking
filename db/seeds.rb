# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

days = Array(25...30)
days.each do |day|
  hours = Array(0...24)
  hours.each do |value|
    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 6, day, value, 0, 0),
      end_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 15.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 15.minutes,
      end_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 30.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 30.minutes,
      end_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 45.minutes,
      is_booked: false)

    Slot.create(uuid: SecureRandom.uuid,
      start_date_time: DateTime.new(2022, 6, day, value, 0, 0) + 45.minutes,
      end_date_time: DateTime.new(2022, 6, day, value + 1, 0, 0),
      is_booked: false)
  end
end
