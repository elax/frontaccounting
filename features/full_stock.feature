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
		# A-Black +4, A-Red +6, B-Black+1  A-Red +5 GBPUSD = 1.50 
		# Invoce GBPUSD = 1.60
		# Transfer A-Black 4 -> WH1
		#
		# A-Black => -0 A-Red -12, B-Black -1, B-Red -10
		# Transfer A-Black WH1 -> DEF
		# A-Red + 6 B-Red +6
		# Credit Everything supplier
		# Credit Everything customer
		# Check GL = 0



