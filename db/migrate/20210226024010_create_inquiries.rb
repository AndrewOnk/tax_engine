class CreateInquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :inquiries do |t|
      t.decimal :income, precision: 12, scale: 2
      t.integer :year
      t.decimal :tax_amount, precision: 12, scale: 2

      t.timestamps
    end
  end
end
