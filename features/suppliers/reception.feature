@db:en_US-ab @supplier @grn @invoice
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
			| due_date  | 01/08/2014 |
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
			| ST_SUPPRECEIVE | 1510 | A-Black | 10 | # inventory
			| ST_SUPPRECEIVE | 1510 | B-Black | 200 |
			| ST_SUPPRECEIVE | 1510 | A-Red   | 30 |
			| ST_SUPPRECEIVE | 1510 | B-Red   | 400 |
			| ST_SUPPRECEIVE | 1550 |         | -640 | GRN clearance
			# Invoice
			| ST_SUPPINVOICE | 2150 |         | 32 |
			| ST_SUPPINVOICE | 2100 |         | -672 |
			| ST_SUPPINVOICE | 1550 |         | 10 |
			| ST_SUPPINVOICE | 1550 |         | 200 |
			| ST_SUPPINVOICE | 1550 |         | 30 |
			| ST_SUPPINVOICE | 1550 |         | 400 |
			
		Then the query "SELECT account, SUM(amount) AS amount FROM 0_gl_trans GROUP BY account" should return:
			| account | amount |
			| 1510    | 640    |
			| 1550    |  0     |
			| 2100    | -672   |
		  | 2150    | 32     |

	Scenario: Direct GRN + Invoice
		Given I'm logged
		# Creating a direct GRN
		Given I am on "Purchases/Direct_GRN"
		When I fill the purchase cart:
			| stock_id | quantity | price |
			| A-Black | 10 | 7 | 
			| B-Black | 20 | 97 | 
			| A-Red | 30 | 7 | 
			| B-Red | 40 | 97 | 
		And I fill in or select the following:
			| supplier_id | S1 |
			| OrderDate | 12/09/2013 |
			| supp_ref  | 1          |
			| StkLocation | WH2      |
		When I press "Process GRN"
		Then I should have the following quantity on hands:
			| stock_id | location | quantity |
			| A-Black  | WH2      | 10       |
			| A-Red    | WH2      | 30       |
			| B-Black  | WH2      | 20       |
			| B-Red    | WH2      | 40       |
		Then the query "SELECT type, account, memo_ as memo,  amount FROM 0_gl_trans WHERE tran_date = '2013/12/09' " should return:
			| type | account | memo | amount |
			| ST_SUPPRECEIVE | 1510 | A-Black | 70 | # inventory
			| ST_SUPPRECEIVE | 1510 | B-Black | 1940 |
			| ST_SUPPRECEIVE | 1510 | A-Red   | 210 |
			| ST_SUPPRECEIVE | 1510 | B-Red   | 3880 |
			| ST_SUPPRECEIVE | 1550 |         | -6100 | GRN clearance

			# Invoicing the delivery
		When I am on "Purchases/Supplier_Invoices"
		And I press "Add All Items"
		And I fill in or select the following:
			| supplier_id | S1 |
			| tran_date | 12/10/2013 |
			| due_date  | 01/10/2014 |
			| supp_reference  | 3          |
			| reference | re3          |
		When I press "Enter Invoice"
		And I follow "click"
		And I follow "View the GL Journal Entries for this Invoice"
		And show last response
		Then I should have on the Journal View:
			| Account Code | Account Name                    | Dimension | Debit    | Credit   | Memo |
			| 	 2150      |  Sales Tax                      |           |   305.00 |          |      |
			| 	 2100      |  Accounts Payable               |           |          | 6,405.00 |      |
			| 	 1550      |  Goods Received Clearing account|           |     70.00|          |      |
			| 	 1550      |  Goods Received Clearing account|           |  1,940.00|          |      |
			| 	 1550      |  Goods Received Clearing account|           |    210.00|          |      |
			| 	 1550      |  Goods Received Clearing account|           |  3,880.00|          |      |
			
		Then the query "SELECT type, account, memo_ as memo,  amount FROM 0_gl_trans WHERE tran_date = '2013/12/10' " should return:
			| type           | account | memo | amount |
			| ST_SUPPINVOICE | 2150 |         | 305 |
			| ST_SUPPINVOICE | 2100 |         | -6405 |
			| ST_SUPPINVOICE | 1550 |         | 70 |
			| ST_SUPPINVOICE | 1550 |         | 1940 |
			| ST_SUPPINVOICE | 1550 |         | 210 |
			| ST_SUPPINVOICE | 1550 |         | 3880 |

		 
			



