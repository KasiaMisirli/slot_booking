require "spec_helper"

RSpec.describe SlotsController, type: :request do
  describe "#index" do
    context "when there are no available slots" do
      it "returns an empty array" do
        get "/slots?date=2022-06-27T00:00:00+00:00&minutes=44"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_empty
      end
    end

    context "when all slots are available" do
      before do
        days = [27, 28]
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
      end

      it "returns available slot only" do
        get "/slots?date=2022-06-27T00:00:00+00:00&minutes=44"

        parsed_response = JSON.parse(response.body)

        expect(parsed_response.length).to eq(96)
        expect(parsed_response.first).to eq({"start_time" => "2022-06-27T00:00:00+00:00", "end_time" => "2022-06-27T00:45:00.000+00:00"})
      end

      context "when some slots are booked" do
        let!(:available_slot_requested_day) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
            start_date_time: "2022-06-25T00:00:00 00:00",
            end_date_time: "2022-06-25T00:15:00 00:00",
            is_booked: false)
        }
        let!(:available_slot_requested_day_2) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-4204990102",
            start_date_time: "2022-06-25T00:15:00 00:00",
            end_date_time: "2022-06-25T00:30:00 00:00",
            is_booked: false)
        }
        let!(:available_slot_requested_day_3) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-4204990103",
            start_date_time: "2022-06-25T00:30:00 00:00",
            end_date_time: "2022-06-25T00:45:00 00:00",
            is_booked: false)
        }

        let!(:booked_slot_requested_day_1) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b941",
            start_date_time: "2022-06-25T00:45:00 00:00",
            end_date_time: "2022-06-25T01:00:00 00:00",
            is_booked: true)
        }
        let!(:available_slot_requested_day_4) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901042",
            start_date_time: "2022-06-25T01:00:00 00:00",
            end_date_time: "2022-06-25T01:30:00 00:00",
            is_booked: false)
        }
        let!(:available_slot_requested_day_5) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-4204990143",
            start_date_time: "2022-06-25T01:30:00 00:00",
            end_date_time: "2022-06-25T01:45:00 00:00",
            is_booked: false)
        }

        let!(:available_slot_requested_day_6) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b904",
            start_date_time: "2022-06-25T01:45:00 00:00",
            end_date_time: "2022-06-26T02:00:00 00:00",
            is_booked: false)
        }

        it "returns only the available durations" do
          get "/slots?date=2022-06-25T00:00:00+00:00&minutes=20"

          parsed_response = JSON.parse(response.body)
          expect(parsed_response.length).to eq(4)
          expect(parsed_response).to eq(
            [
              {"start_time" => "2022-06-25T00:00:00 00:00", "end_time" => "2022-06-25T00:30:00.000+00:00"},
              {"start_time" => "2022-06-25T00:15:00 00:00", "end_time" => "2022-06-25T00:45:00.000+00:00"},
              {"start_time" => "2022-06-25T01:00:00 00:00", "end_time" => "2022-06-25T01:30:00.000+00:00"},
              {"start_time" => "2022-06-25T01:30:00 00:00", "end_time" => "2022-06-25T02:00:00.000+00:00"}
            ]
          )
        end
      end
    end
  end

  describe "#update" do
    context "when correct dates are passed" do
      context "and slot is found" do
        let!(:available_slot) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
            start_date_time: 1.week.from_now,
            end_date_time: 1.week.from_now + 15.minutes,
            is_booked: false)
        }

        it "updates the slot" do
          put "/slots/ef376938-cd49-48b2-b647-42049901b906"
          expect(response).to have_http_status(:ok)

          parsed_response = JSON.parse(response.body)
          expect(parsed_response["uuid"]).to eq(available_slot.uuid)
          expect(parsed_response["is_booked"]).to be(true)
        end
      end

      context "and slot is not found" do
        it "throws not found error" do
          put "/slots/ef376938-cd49-48b2-b647-42049901b100"

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when incorrect uuid is passed" do
      it "throws a bad request error" do
        put "/slots/incorrect-uuid"
        expect(response).to have_http_status(:bad_request)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["error"]).to eq("The request has failed validation")
      end
    end
  end
end
