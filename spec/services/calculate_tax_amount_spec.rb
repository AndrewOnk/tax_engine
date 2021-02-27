require 'rails_helper'

RSpec.describe CalculateTaxAmount do
  let(:inquiry) { FactoryBot.create(:inquiry, income: income) }
  let(:income) { 45_000 }
  let(:async) { true }
  let(:service) { described_class.new(inquiry: inquiry, async: async) }

  describe '#inquiry' do
    subject { service.inquiry }

    it 'returns inquiry' do
      is_expected.to eq(inquiry)
    end
  end

  describe '#call' do
    subject { service.call }
    context 'when inquiry year is 2021' do
      context 'when income is in 1st tax bracket' do
        context 'when income is on lower edge' do
          let(:income) { 0.00 }

          it 'updates inquiry to tax_amount to 0.0' do
            subject
            expect(inquiry.reload.tax_amount).to eq(0.0)
          end
        end

        context 'when income is in middle' do
          let(:income) { 5_000.00 }

          it 'updates inquiry to tax_amount to 0.0' do
            subject
            expect(inquiry.reload.tax_amount).to eq(0.0)
          end
        end

        context 'when income is in upper edge' do
          let(:income) { 10_000.00 }

          it 'updates inquiry to tax_amount to 0.0' do
            subject
            expect(inquiry.reload.tax_amount).to eq(0.0)
          end
        end
      end

      context 'when income is in 2nd tax bracket' do
        context 'when income is on lower edge' do
          let(:income) { 10_000.01 }

          it 'updates inquiry to tax_amount to 0.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(0.00)
          end
        end

        context 'when income is in middle' do
          let(:income) { 15_000.00 }

          it 'updates inquiry to tax_amount to 500.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(500.00)
          end
        end

        context 'when income is in upper edge' do
          let(:income) { 20_000.00 }

          it 'updates inquiry to tax_amount to 1_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(1_000.00)
          end
        end
      end

      context 'when income is in 3rd tax bracket' do
        context 'when income is on lower edge' do
          let(:income) { 20_000.01 }

          it 'updates inquiry to tax_amount to 1_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(1_000.00)
          end
        end

        context 'when income is in middle' do
          let(:income) { 35_000.00 }

          it 'updates inquiry to tax_amount to 4_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(4_000.00)
          end
        end

        context 'when income is in upper edge' do
          let(:income) { 50_000.00 }

          it 'updates inquiry to tax_amount to 7_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(7_000.00)
          end
        end
      end

      context 'when income is in 4th tax bracket' do
        context 'when income is on lower edge' do
          let(:income) { 50_000.01 }

          it 'updates inquiry to tax_amount to 1_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(7_000.00)
          end
        end

        context 'when income is in middle' do
          let(:income) { 150_000.00 }

          it 'updates inquiry to tax_amount to 37_000.00' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(37_000.00)
          end
        end

        context 'when income is in upper edge' do
          let(:income) { 9999999999.99 }

          it 'updates inquiry to tax_amount to 2_999_991_999.99' do
            subject
            expect(inquiry.reload.tax_amount.to_f).to eq(2_999_991_999.99)
          end
        end
      end
    end
  end
end
