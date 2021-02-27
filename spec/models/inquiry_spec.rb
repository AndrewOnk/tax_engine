require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  let(:inquiry) { FactoryBot.build(:inquiry) }

  describe 'validations' do
    describe 'income' do
      it { should validate_numericality_of(:income).is_greater_than_or_equal_to(Inquiry::MIN_INCOME) }
      it { should validate_numericality_of(:income).is_less_than_or_equal_to(Inquiry::MAX_INCOME) }
    end
    describe 'year' do
      it { should validate_numericality_of(:year).is_greater_than_or_equal_to(Inquiry::START_YEAR) }
      it { should validate_numericality_of(:year).is_less_than_or_equal_to(Date.current.year) }
    end
  end

  describe 'before_create' do
    describe '#calculate_tax_amount' do

      subject { inquiry.save }

      it 'calls CalculateTaxAmount service' do
        expect_any_instance_of(CalculateTaxAmount).to receive(:call)
        subject
      end
    end
  end

  xdescribe 'after_create' do
    subject { inquiry.save }

    it 'calls calculate_tax_amount_async' do
      expect(inquiry).to receive(:calculate_tax_amount_async)
      subject
    end
  end
end
