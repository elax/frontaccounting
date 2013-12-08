@db:en_US-ab
Feature:
	As a user I want to check that the different 
	ways of receiving some goods from a supplier
	generate the same things. The different ways are
	- Direct Invoice
	- Direct GRN + Invoice
	- Order + GRN + Invoice


	Scenario: Direct Invoice
		Given I'm logged
		Given I am on "Purchases/Direct_Invoice" 
		When I fill the purchase cart:
			| stock_id | quantity | price |
			| A-Black | 1 | 10 | 
			| B-Black | 2 | 100 | 
			| A-Red | 3 | 10 | 
			| B-Red | 4 | 100 | 
		# Order parameters needs to be filled afterward
		# in case they get resetted by AJAX calls.
		And I fill in or select the following:
			| supplier_id | S1 |
			| OrderDate | 12/08/2013 |
			| due_date  | 12/23/2013 |
			| supp_ref  | 1          |
			| StkLocation | WH1      |
		When I press "Process Invoice"
		Then I should have the following quantity on hands:
			| stock_id | location | quantity |
			| A-Black  | WH1      | 1        |
			| A-Red    | WH1      | 3        |
			| B-Black  | WH1      | 2        |
			| B-Red    | WH1      | 4        |
			
		Then the query "SELECT type, account, memo_ as memo,  amount FROM 0_gl_trans" should return:
			| type | account | memo | amount |
			| ST_SUPPRECEIVE | 1510 | A-Black | 10 |
			| ST_SUPPRECEIVE | 1510 | B-Black | 200 |
			| ST_SUPPRECEIVE | 1510 | A-Red   | 30 |
			| ST_SUPPRECEIVE | 1510 | B-Red   | 400 |
			| ST_SUPPRECEIVE | 1550 |         | -640 |
			



