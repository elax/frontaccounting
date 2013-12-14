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

		# Invoce GBPUSD = 1.60
		# Transfer A-Black 4 -> WH1
		#
		# A-Black => -0 A-Red -12, B-Black -1, B-Red -10
		# Transfer A-Black WH1 -> DEF
		# A-Red + 6 B-Red +6
		# Credit Everything supplier
		# Credit Everything customer
		# Check GL = 0



