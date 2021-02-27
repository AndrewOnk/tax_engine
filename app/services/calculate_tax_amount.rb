require "yaml"

class CalculateTaxAmount
  attr_reader :inquiry, :async, :income
  delegate :year, to: :inquiry

  def initialize(inquiry:, async: false)
    @inquiry = inquiry
    @async = async
    @income = inquiry.income
  end

  def call
    tax_amount = 0.0
    tax_brackets.each do |bracket|
      if income >= bracket[:income_high]
        if bracket[:max_tax_amount].present?
          tax_amount += bracket[:max_tax_amount]
        else
          tax_amount += (income - bracket[:income_low]) * bracket[:tax]
        end
      else
        tax_amount += (income - bracket[:income_low]) * bracket[:tax]
        break
      end
    end
    inquiry.tax_amount = tax_amount
    if async
      inquiry.save
      notify_user
    end
  end

  private

  def tax_brackets
    @tax_brackets ||= YAML.load_file(Rails.root.join('config', 'tax_brackets', "#{year}.yml"))
                          .with_indifferent_access[:brackets]
  end

  def notify_user
    puts 'Send notification to the user that his tax_amount calculation is completed'
  end
end
