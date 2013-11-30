Feature: Journal Entry
	An account can post GL entry manually.
	It should appear in the database.

	Scenario: Enter Journal Entry
		Given I have a COA
		When I post a 100.00 to account 1500	
		Then the GL transaction should includes:
			|  account  |  debit  |  credit  |
			|  1500     |  100    |  0|


