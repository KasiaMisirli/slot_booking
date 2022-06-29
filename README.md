# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version
ruby 3.1.2
Rails 7.0.3

- Database initialization

rails db:migrate
rails db:seed

- How to run the test suite

rails c -> Will spin up both react and rails.

In your browser, go to "http://localhost:3000" and you should be able to see the homepage where you can select time to see slots available.

GET to see the slots available:

GET "http://localhost:3000/slots?date=2022-02-01T00:00:00+00:00&minutes=45"

PUT to book slot:

PUT "http://localhost:3000/slots" params: {start_date: "2022-01-25T00:00:00+00:00", end_date: "2022-01-25T00:30:00+00:00"}
