require 'watir'
require 'forgery'

b = Watir::Browser.new

#update to your creds
admin_url = 'ADMIN_URL'
orders = 3
#login
b.goto admin_url
b.text_field(:name=>'username').set 'USERNAME'
b.text_field(:name=>'password').set 'PASSWORD'
b.button(:type => 'submit').click

orders.times do |i|
	#add order
	b.span(:text => 'Orders').when_present.click
	b.span(:text => 'Add an Order').click

	#new customer
	r = b.label(:text=>'A new customer or in-store purchase').parent.radio :value => 'new'
	r.set

	#fill the form
	b.text_field(:id=>'FormField_4').set Forgery(:name).first_name
	b.text_field(:id=>'FormField_5').set Forgery(:name).last_name
	b.text_field(:id=>'FormField_6').set Forgery(:name).company_name
	b.text_field(:id=>'FormField_7').set Forgery(:address).phone
	b.text_field(:id=>'FormField_8').set Forgery(:address).street_address
	b.text_field(:id=>'FormField_10').set Forgery(:address).city
	s = b.select_list :name => 'FormField[2][11]'
	s.select 'United States'
	s = b.select_list :name => 'FormField[2][12]'
	s.when_present.select Forgery(:address).state
	b.text_field(:id=>'FormField_13').set Forgery(:address).zip
	b.label(:text => "Save to customer's address book").click
	b.button(:class => 'orderMachineNextButton', :index => 1).click

	#add a product
	b.link(:text => 'Add a custom product...').when_present.click
	#b.link(:class => 'addVirtualItemLink',:index => 0).click
	b.text_field(:name=>'name').when_present(2).set Forgery(:name).full_name + ' Signature Collection'
	b.text_field(:name=>'price').when_present.set Forgery(:monetary).money(:min => 25, :max => 100) 
	b.button(:text => 'Add Item').click

	#next
	sleep(1)
	b.button(:class => 'orderMachineNextButton', :index => 1).when_present.click

	#next
	b.button(:class => 'orderMachineNextButton', :index => 1).when_present.click

	#payment
	s = b.select_list :name => 'paymentMethod'
	s.when_present.select 'Manual Payment'
	# Email Invoice to Customer?
								

	b.input(:name=> 'emailInvoiceToCustomer').click
	b.button(:class => 'orderMachineSaveButton orderSaveButton', :index => 0).click
	sleep(1)
	#new order
	if i < orders
		b.goto admin_url
		sleep(1)
	end
end
