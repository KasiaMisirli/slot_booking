class UpdateSlotContract < Dry::Validation::Contract
  params do
    required(:uuid).filled(:string)
  end

  rule(:uuid) do
    unless /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/i.match?(value)
      key.failure("has invalid format")
    end
  end
end
