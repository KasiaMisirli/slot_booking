require "rails_helper"

RSpec.describe SlotsController, type: :request do
  context "when there are no available slots" do
    it "returns [] when there are no available slots" do
      get "/slots"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_empty
    end
  end

  context "when there are available slots" do
    let!(:available_slot) {
      Slot.create!(uuid: "ef376938-cd49-48b2-b647-42049901b906",
        start_date_time: Time.now + 1.week,
        end_date_time: Time.now + 1.week + 15.minutes,
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

    it "returns available slots only" do
      get "/slots"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(1)
      expect(parsed_response.first["uuid"]).to eq(available_slot.uuid)
      expect(parsed_response.first["start_date_time"]).to eq(available_slot.start_date_time)
      expect(parsed_response.first["end_date_time"]).to eq(available_slot.end_date_time)
    end

    it "returns future slots only" do
        get "/slots"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(1)
        expect(parsed_response.first["uuid"]).to eq(available_slot.uuid)
        expect(parsed_response.first["start_date_time"]).to eq(available_slot.start_date_time)
        expect(parsed_response.first["end_date_time"]).to eq(available_slot.end_date_time)
      end
  end
end
