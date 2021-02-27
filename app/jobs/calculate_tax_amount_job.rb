class CalculateTaxAmountJob < ApplicationJob
  queue_as :tax_calculate

  def perform(inquiry_id)
    CalculateTaxAmount.new(inquiry: Inquiry.find(inquiry_id)).call
  end
end