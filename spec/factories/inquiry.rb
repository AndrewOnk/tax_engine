FactoryBot.define do
  factory :inquiry do
    income { 30_000 }
    year { 2021 }
    tax_amount { nil }
  end
end