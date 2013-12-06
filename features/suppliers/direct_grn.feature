@db:en_US-ab
Feature: Direct GRN
	As a user I should be able to place a purchase order.
	This order could be delivered and invoiced.

	Scenario: Place Order
		Given I'm logged 
		When "S1" do a direct GRN to "DEF":
			| stock_id | quantity | price |
			| A-Black | 6 | 10 | 
			| B-Black | 5 | 100 | 
		When "S1" do a direct GRN to "DEF":
			| stock_id | quantity | price |
			| B-Black | 1 | 100 | 
		Then I should have the following quantity on hands:
			| stock_id | location | quantity |
			| A-Black  | | 6        |
			| B-Black  | DEF    | 5        |
		
		


