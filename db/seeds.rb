# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

  #QuestionType.destroy_all
  #QuestionType.create(:name => 'Radio', :value => 'radio')
  #QuestionType.create(:name => 'Checkbox', :value => 'checkbox')  
  
  PaymentMethod.destroy_all
  PaymentMethod.create(:name => 'Check', :short_code => 'check')
  PaymentMethod.create(:name => 'Paypal', :short_code => 'paypal')

require 'csv'

state_file = "#{Rails.root}/db/state.csv"

begin
  p "Creating states"
  states = CSV.read(state_file, :headers => true, :header_converters => :symbol)
  states.each do |row|
    State.create!(:state => row[0], :state_code => row[1])
  end
  p "Successfully Created States"
end
