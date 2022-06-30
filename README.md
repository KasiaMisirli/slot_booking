# README

- Ruby version
  ruby 3.1.2
  Rails 7.0.3

- Database initialization

`rails db:migrate`

`rails db:seed`

- How to run the app

1. Clone the repo
   `git clone https://github.com/KasiaMisirli/slot_booking.git`

Assuming you have ruby & rails etc already installed, you should be able to run

`npm install` -> to install node modules

`rails db:migrate` -> to migrate the migrations that I have created

`rails db:seed` -> to seed your database with 2 months of slots as well as the provided booked stots data.

`rails db:reset` -> if you would like to delete your data and seed it again with the provided seed file

`rails c` -> Will spin up both react and rails.

In your browser, go to "http://localhost:3000" and you should be able to see the homepage where you can select time to see slots available.

Once selected, the slot gets booked and remaining slots get displayed.

`bundle exec rubocop -A` -> To run the formatter

- Endpoints used:

1. GET to see the slots available:

GET "http://localhost:3000/slots?date=2022-02-01T00:00:00+00:00&minutes=45"

2. PUT to book slot:

PUT "http://localhost:3000/slots" params: {start_date: "2022-01-25T00:00:00+00:00", end_date: "2022-01-25T00:30:00+00:00"}

These endpoints can also be tested via postman/Insomnia

- Rspec tests

`bundle exec rspec spec` -> to run test

- Possible impovements:

1. Ruby on Rails:

- Add Repository to store all the interactions with db in one place
- Make the validation of input more stict (only allow digits)
- Chance command/query for dry types check and add command handler/query handler
- Prepopulate the db to more them two months and ideally in the future :) I prepopulated for January and February 2022 as the booked dates provided where around that time.

2. React:

- Visual impovements
- Allow input of hours and minutes for better UX etc
- Add a nicer notification to inform user of the success or even add a modal to confirm with user if their sure they want to select a given slot. Once confimed in the modal, make the API call.
- Add websockets so two users could interact with the slots in real time (always see only the slots that are available, rather then seeing response from the API that doesnt get updated even when others already took the spot. In that situaction, we need to relay on PUT endpoint to validate the request again.)
