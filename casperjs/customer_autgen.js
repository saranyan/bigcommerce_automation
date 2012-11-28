//Copyright (c) 2012 Saranyan

var system = require('system');
var utils = require('utils');

//update to your creds
var username = 'USERNAME', password = 'PASSWORD';
var admin_store_url = 'ADMIN_URL'; //have to login first here

//a fake server I setup that gives fake data in JSON format
//you don't need to do it this way - but gives an appreciation of AJAX and casper
//playing together

var fake_data_url = 'http://localhost:5000/data/bigcommerce'; //gives a JSON data dump
var casper = require('casper').create({
    pageSettings: {
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.10 (KHTML, like Gecko) Chrome/23.0.1262.0 Safari/537.10'
    },
    viewportSize: {
        width: 1024,
        height: 768
    },
    verbose: true,
    logLevel: 'debug'
});

var data;

//login first

casper.start(admin_store_url, function enterCreds() {
	this.fill('form[id="frmLogin"]', {
        'username': username,
        'password': password
    }, false);
});

casper.then(function login() {
    this.click('.btn')[0];
});

//after you login add customers
casper.waitForSelector('.DashboardRightColumn', function() {
     //click customers
     this.click('a#SubMenuAddCustomers');
 });

//how many customers do you want to add?
casper.repeat(3, function(){
	//get fake data about customers
	casper.then(function getFakeData(){
		data = this.evaluate(function(fake_data_url){
			return JSON.parse(__utils__.sendAJAX(fake_data_url+"/customer", 'GET', null, false));
		},{fake_data_url:fake_data_url})
		
	});

	casper.then(function(){
		require('utils').dump(data);
	});
	
	casper.then(function addCustomer(){

		this.fill('form[id="frmCustomer"]', {
	        'custFirstName': data.first_name,
	        'custLastName': data.last_name,
	        'custEmail': data.email_address,
	        'custPassword': 'testcustomer',
	        'custPasswordConfirm': 'testcustomer'
	    }, false);
	});
	
	casper.then(function createCustomer(){
		//create above customer (save and add another)
		//users the old UI. not the  modern UI. This selector will change.
		//casper.test.assertExists('input[name="SaveContinueButton2"]', 'the element exists');
		this.click('input[name="SaveContinueButton2"]')[0];
	});
});



casper.run(function() {
    this.exit();
});
