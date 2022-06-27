# frozen_string_literal: true

class UpdateSlotContract < Dry::Validation::Contract
  params do
    # possible impovement: require DateTime dry type
    required(:start_date).value(min_size?: 25)
    required(:end_date).value(min_size?: 25)
  end
end
