@full @db:en_US-ab
Feature: Full Stock
	As an accountant I want to test
	the full stock cycle (from supplier to customer)
	generate the appropriate GL entry.


	Scenario: full stock cycle including credit note, and negative inveentory
		# First we set some quantity for all items
		# transfer some item in an other location
		# so that the item is in negative stock from the default location.
		# dispatch to the customer so some item are negatives
		# fill negative stock so q=0 and q > dispatch to the customer so some item are negatives
		# fill negative stock so q=0 and q > 0
		#
		#
		Given I'm logged
		Given I have the following exchange rates:
			| currency | date | rate |
			| GBP | 12/01/2013 | 0.65 |
			| GBP | 12/02/2013 | 0.70 |

		# A-Black +4, A-Red +6, B-Black+1  B-Red +5 GBPUSD = 1.50 
		And I am on "Purchases/Direct_GRN"
		When I fill the purchase cart:
			| stock_id | quantity | price |
			| A-Black | 15 | 4 | 
			| B-Black | 150 | 1 | 
			| A-Red | 30 | 6 | 
			| B-Red | 200 | 5 | 
		And I fill in or select the following:
			| supplier_id | S2 |
			| OrderDate | 12/01/2013 |
			| supp_ref  | 1          |
			| StkLocation | DEF      |
		When I press "Process GRN"
		Then the query "SELECT type, account, memo_ as memo,  amount FROM 0_gl_trans WHERE tran_date = '2013-12-01'" should return:
			| type | account | memo | amount |
			| ST_SUPPRECEIVE | 1510 | A-Black | 39 |
			| ST_SUPPRECEIVE | 1510 | B-Black | 97.50 |
			| ST_SUPPRECEIVE | 1510 | A-Red   | 117 |
			| ST_SUPPRECEIVE | 1510 | B-Red   | 650 |
			| ST_SUPPRECEIVE | 1550 |         | -903.5 |

		# Invoce GBPUSD = 1.60
		When I am on "Purchases/Supplier_Invoices"
		And I fill in or select the following:
		# We need to set the date before the supplier
		# so that the correct date is used to find the exchange rate
			| tran_date | 12/02/2013 |
			| due_date  | 01/10/2014 |
			| supp_reference  | 1          |
			| reference | 1          |
		And I select "S2" from "supplier_id"
		And I wait 10 seconds
		Then show last response
		Then I should see "A-Black"
		And I press "Add All Items"
		When I press "Enter Invoice"

		# Transfer A-Black 4 -> WH1
		#
		# A-Black => -0 A-Red -12, B-Black -1, B-Red -10
		# Transfer A-Black WH1 -> DEF
		# A-Red + 6 B-Red +6
		# Credit Everything supplier
		# Credit Everything customer
		# Check GL = 0



