class FindSlotsContract < Dry::Validation::Contract
  params do
    required(:date).filled(:string)
    required(:minutes).filled(:integer)
  end
end
