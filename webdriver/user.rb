#Copyright (c) 2012 Saranyan

require 'watir'
require 'forgery'

ARGV.length == 3 ? nil : (raise "Argument reqd")

b = Watir::Browser.new
admin_url = 'ADMIN_STORE_URL'


user_name = ARGV[0]
user_pass = ARGV[1]
user_email = ARGV[2]


#login
b.goto admin_url
b.text_field(:name=>'username').set 'saranyan'
b.text_field(:name=>'password').set '__bigcommerce7__'
b.button(:type => 'submit').click

b.link(:id => 'mnuUsersMenuButton').when_present.click
b.button(:text => 'Create a User Account...').click

#fill the form
b.text_field(:id=>'username').set user_name
b.text_field(:id=>'userpass').set user_pass
b.text_field(:id=>'userpass1').set user_pass
b.text_field(:id=>'useremail').set user_email

b.link(:onclick => "SetupPermissions('admin', false); return false;").click
b.label(:text => 'Yes, allow this user to use the API').when_present.click

#b.span(:text => 'Create a User Account...').click
b.button(:name => 'SaveButton2', :index => 0).when_present.click