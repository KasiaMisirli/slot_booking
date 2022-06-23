require "rails_helper"

RSpec.describe SlotsController, type: :request do
  describe "#index" do
    context "when there are no available slots" do
      it "returns an empty array" do
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_empty
      end
    end

    context "when there is an available slot" do
      let!(:available_slot) {
        Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
          start_date_time: 1.week.from_now,
          end_date_time: 1.week.from_now + 15.minutes,
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
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["uuid"]).to eq(available_slot.uuid)
        expect(parsed_response.first["start_date_time"]).to eq(available_slot.start_date_time)
        expect(parsed_response.first["end_date_time"]).to eq(available_slot.end_date_time)
      end

      it "returns future slot only" do
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["uuid"]).to eq(available_slot.uuid)
        expect(parsed_response.first["start_date_time"]).to eq(available_slot.start_date_time)
        expect(parsed_response.first["end_date_time"]).to eq(available_slot.end_date_time)
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

        it "returns multiple slots" do
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
          put "/slots/ef376938-cd49-48b2-b647-42049901b906"

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
