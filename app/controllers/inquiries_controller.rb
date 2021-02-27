class InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.new(income: inquiry_params[:income], year: Date.current.year)

    return render json: inquiry.errors, status: :unprocessable_entity unless inquiry.save

    render json: { data: inquiry }, status: :created
  end

  private

  def inquiry_params
    params.require(:parameters).permit(:income)
  end
end
