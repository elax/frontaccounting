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
		When I fill in or select the following:
			| supplier_id | S1 |
			| OrderDate | 12/08/2013 |
			| due_date  | 12/23/2013 |
			| supp_ref  | 1          |
			| StkLocation | DEF      |
		And I fill the purchase cart:
			| stock_id | quantity | price |
			| A-Black | 1 | 10 | 
			| B-Black | 2 | 100 | 
			| A-Red | 3 | 10 | 
			| B-Red | 4 | 100 | 
		Then show last response



