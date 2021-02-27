class Inquiry < ApplicationRecord
  MIN_INCOME = 0
  MAX_INCOME = 9_999_999_999.99
  START_YEAR = 1960

  validates :income, numericality: { greater_than_or_equal_to: MIN_INCOME, less_than_or_equal_to: MAX_INCOME }
  validates :year, numericality: { greater_than_or_equal_to: START_YEAR, less_than_or_equal_to: Proc.new {|_record| Date.current.year } }

  before_create :calculate_tax_amount, unless: ENV['ASYNC_TAX_AMOUNT_CALCULATION']
  after_create :calculate_tax_amount_async,  if: ENV['ASYNC_TAX_AMOUNT_CALCULATION']

  def calculate_tax_amount
    CalculateTaxAmount.new(inquiry: self).call
  end

  def calculate_tax_amount_async
    CalculateTaxAmountJob.perform_later(id)
  end
end
