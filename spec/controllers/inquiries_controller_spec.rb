require 'rails_helper'

RSpec.describe InquiriesController, type: :request do
  describe '#create' do
    context 'when income is invalid' do
      it 'returns error message' do
        post inquiries_path, params: { parameters: { income: -1000 } }, headers: { "ACCEPT" => "application/json" }

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when income is valid' do
      it 'returns error message' do
        post inquiries_path, params: { parameters: { income: 1000 } }, headers: { "ACCEPT" => "application/json" }

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:created)
      end
    end
  end
end