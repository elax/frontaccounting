Feature: Test ZombieJS headless browser
	Scenario:
		Given I am on "/"
		Then print last response
					And I fill in "password" with "password"
		When I fill in "user_name_entry_field" with "admin"
					And I fill in "password" with "password"
			And I press "Login"
		Then I should see "Sales"
		When I follow "Sales"
		Then show last response

