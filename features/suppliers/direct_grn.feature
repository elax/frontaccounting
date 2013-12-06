@db:us-ab
Feature: Direct GRN
	As a user I should be able to place a purchase order.
	This order could be delivered and invoiced.

	Scenario: Place Order
		Given I'm logged 
		When "S1" do a direct GRN to "DEF":
			| stock_id | description | quantity | discount | price |
			| A-Black | | 6 | | 10 | 
			| B-Black | | 5 | | 100 | 
		Then I should have the following quantity on hands:
			| stock_id | location | quantity |
			| A-Black  | 'DEF'    | 6        |
			| B-Black  | 'DEF'    | 1        |
		
		


