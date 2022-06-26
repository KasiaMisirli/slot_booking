require "rails_helper"

RSpec.describe SlotsController, type: :request do
  describe "#index" do
    context "when there are no available slots" do
      xit "returns an empty array" do
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_empty
      end
    end

    context "when there is an available slot" do
      let!(:available_slot_requested_day) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
          start_date_time: "2022-06-25T00:00:00 00:00",
          end_date_time: "2022-06-25T00:15:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_requested_day_2) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b9",
          start_date_time: "2022-06-25T00:15:00 00:00",
          end_date_time: "2022-06-25T00:30:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_requested_day_3) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b9",
          start_date_time: "2022-06-25T00:30:00 00:00",
          end_date_time: "2022-06-25T00:45:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_next_day_1) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-25T23:45:00 00:00",
          end_date_time: "2022-06-26T00:00:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_next_day_2) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-26T00:00:00 00:00",
          end_date_time: "2022-06-26T00:15:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_next_day_3) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-26T00:15:00 00:00",
          end_date_time: "2022-06-26T00:30:00 00:00",
          is_booked: false)
      }

      let!(:available_slot_next_day_11) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-26T00:00:00 00:00",
          end_date_time: "2022-06-26T00:15:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_next_day_22) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-26T00:15:00 00:00",
          end_date_time: "2022-06-26T00:30:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_next_day_33) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b901",
          start_date_time: "2022-06-26T00:30:00 00:00",
          end_date_time: "2022-06-26T00:45:00 00:00",
          is_booked: false)
      }
      let!(:available_slot_3rd_day) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b902",
          start_date_time: "2022-06-27T00:00:00 00:00",
          end_date_time: "2022-06-27T00:15:00 00:00",
          is_booked: false)
      }
      let!(:available_past_slot) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b908",
          start_date_time: DateTime.new(2021, 6, 21, 0, 0, 0) + 30.minutes,
          end_date_time: DateTime.new(2021, 6, 21, 0, 0, 0) + 45.minutes,
          is_booked: false)
      }
      let!(:booked_slot) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b910",
          start_date_time: DateTime.new(2022, 6, 21, 0, 0, 0),
          end_date_time: DateTime.new(2022, 6, 21, 0, 0, 0) + 15.minutes,
          is_booked: true)
      }

      it "returns available slot only" do
        get "/slots?date=2022-06-25T00:00:00+00:00&minutes=44"
        binding.pry
        parsed_response = JSON.parse(response.body)
        binding.pry
        # expect(parsed_response.length).to eq(1)
        # expect(parsed_response.first["uuid"]).to eq(available_slot_requested_day.uuid)
        # expect(parsed_response.first["start_date_time"]).to eq(available_slot_requested_day.start_date_time)
        # expect(parsed_response.first["end_date_time"]).to eq(available_slot_requested_day.end_date_time)
      end

      xit "returns future slot only" do
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["uuid"]).to eq(available_slot_requested_day.uuid)
        expect(parsed_response.first["start_date_time"]).to eq(available_slot_requested_day.start_date_time)
        expect(parsed_response.first["end_date_time"]).to eq(available_slot_requested_day.end_date_time)
      end

      context "when there are multiple slots available" do
        let!(:available_slot) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
            start_date_time: 1.week.from_now,
            end_date_time: 1.week.from_now + 15.minutes,
            is_booked: false)
        }
        let!(:available_slot_2) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b907",
            start_date_time: 1.week.from_now + 15.minutes,
            end_date_time: 1.week.from_now + 30.minutes,
            is_booked: false)
        }

        xit "returns multiple slots" do
          get "/slots"
          parsed_response = JSON.parse(response.body)
          expect(parsed_response.length).to eq(2)
        end
      end
    end
  end

  describe "#update" do
    context "when correct uuid is passed" do
      context "and slot is found" do
        let!(:available_slot) {
          Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
            start_date_time: 1.week.from_now,
            end_date_time: 1.week.from_now + 15.minutes,
            is_booked: false)
        }

        xit "updates the slot" do
          put "/slots/ef376938-cd49-48b2-b647-42049901b906"
          expect(response).to have_http_status(:ok)

          parsed_response = JSON.parse(response.body)
          expect(parsed_response["uuid"]).to eq(available_slot.uuid)
          expect(parsed_response["is_booked"]).to be(true)
        end
      end

      context "and slot is not found" do
        xit "throws not found error" do
          put "/slots/ef376938-cd49-48b2-b647-42049901b906"

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when incorrect uuid is passed" do
      xit "throws a bad request error" do
        put "/slots/incorrect-uuid"
        expect(response).to have_http_status(:bad_request)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["error"]).to eq("The request has failed validation")
      end
    end
  end
end
