require 'rails_helper'

RSpec.describe CalculateTaxAmountJob, type: :job do
  let(:inquiry) { FactoryBot.create(:inquiry) }
  describe "#perform_later" do
    it "uploads a backup" do
      ActiveJob::Base.queue_adapter = :test

      CalculateTaxAmountJob.perform_later('backup')
      expect(CalculateTaxAmountJob).to have_been_enqueued
    end
  end
end