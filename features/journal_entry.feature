@db:en_US-new
Feature: Journal Entry
	An account can post GL entry manually.
	It should appear in the database.

	Scenario: Enter Journal Entry
		As developper I need to be able to save
		a GL transaction to the database.
		When I post a 100.00 to account 1500	
		When I post a -100.00 to account 1600	
		Then the query "select * from 0_gl_trans" should return:
			|  account  |  amount  |
			|  1500     |  100    |
			|  1600     |  -100    |


