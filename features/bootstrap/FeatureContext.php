<?php

use Behat\Behat\Context\ClosuredContextInterface,
	Behat\Behat\Context\TranslatedContextInterface,
	Behat\Behat\Context\BehatContext,
	Behat\Behat\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode,
	Behat\Gherkin\Node\TableNode;

use Behat\Behat\Event\FeatureEvent;

// Steps
use Behat\Behat\Context\Step\Given,
	Behat\Behat\Context\Step\When,
	Behat\Behat\Context\Step\Then;

// Mink

use Behat\MinkExtension\Context\MinkContext;

//
// Require 3rd-party libraries here:
//
//   require_once 'PHPUnit/Autoload.php';
require_once 'PHPUnit/Framework/Assert/Functions.php';

require_once('features/bootstrap/init_connection.inc');

require_once('gl/includes/db/gl_db_trans.inc');

/**
 * Features context.
 */
class FeatureContext extends MinkContext
{
	/**
	 * Initializes context.
	 * Every scenario gets it's own context object.
	 *
	 * @param array $parameters context parameters (set them up through behat.yml)
	 */

	static $db_connection = null;
	static $backup_name;

	public function __construct(array $parameters)
	{
		// Initialize your context here
	}

		/**
		 * @Transform /(-?\d+\.\d+)/
		 */
		public function stringToFload($string) {
			return floatval($string);
		}

	static $routeMap = array(
		'Purchases/Direct_Invoice' => '/purchasing/po_entry_items.php?NewInvoice=Yes',
		'Purchases/Direct_GRN' => '/purchasing/po_entry_items.php?NewGRN=Yes'
	);
		/** 
		 * @Transform /(.+\/.*)/
		 */
	public function transformRouteToUrl($route) {
		if(isset(self::$routeMap[$route]))
			return self::$routeMap[$route] ;
		else
		 return	$route;
	}


		public static function initConnection() {
			if(self::$db_connection) {
				return self::$db_connection;
			}

			self::$db_connection = init_db_connection();
			return  self::$db_connection;

		}


	public static function restore_db($backup_name=null) {
		if(!is_null($backup_name)) {
			self::$backup_name = $backup_name;
		}

		return db_import("features/fixtures/$backup_name", self::initConnection());
	}


	/**
 * @BeforeFeature
 *
 */
	public static function auto_import_db(FeatureEvent $event) {
			self::db_import_from_tags($event->getFeature()->getTags());
	}

	/* Scan tags to find one like @db:<backup_name> and import it to the database. */
	public static function db_import_from_tags(array $tags) {
		foreach($tags as $tag) {
			if(sscanf($tag, 'db:%s', $name)) {
				return self::restore_db("$name.sql");
			}
		}
	}



		/**
		 * @When /^I post a (-?\d+\.\d+) to account (\d+)$/
		 */
		public function iPostAToAccount($amount, $account)
		{

			$type = ST_JOURNAL;
			$trans_id = 1;
			$date = '2013/12/01';
			add_gl_trans($type, $trans_id, $date, $account, null, null, "", $amount);
		}


    /**
     * @Then /^the query "([^"]*)" should return:$/
		 * This function compares the result of an sql query
		 * with a table
     */
    public function theQueryShouldReturn($sql, TableNode $table)
    {
			$query = db_query($sql);
			foreach($table->getHash() as $expected_row) {
				$row = db_fetch($query);
				assertEquals(false, is_null($row));
				foreach($expected_row as $key => $value) {
					assertEquals($value, @$row[$key]);
				}
			}
				$row = db_fetch($query);
			// we shouldn't have any row left
				assertEquals(false, $row);
			
    }


    /**
     * @Given /^I\'m logged$/
     */
    public function iMLogged()
    {
			return array(
				new Given('I am on "/"'),
				new Then('I fill in "user_name_entry_field" with "admin"'),
				new Then('I fill in "password" with "password"'),
				new Then('I press "Login"')
			);
    }

    /**
     * @When /^"([^"]*)" do a direct GRN to "DEF":$/
     */
    public function doADirectGrnToDef($supplier, TableNode $table)
    {
			return array(
				new Given('I am on "Purchases/Direct_GRN"'),
				new Given('I select "S1" from "supplier_id"'),
				new When('I fill the purchase cart:', $table),
				new Then('I press "Process GRN"'),
				new Then('I follow "click"'), # follow redirection
			);
    }

		/**
			* @When /^I fill the purchase cart:/
			*/
		public function iFillThenPurchaseCart(TableNode $table) {
				$element_map = array(#'stock_id' => '_stock_id_edit',
					'quantity' => 'qty',
				);
									
				$steps = array();
				foreach($table->getHash() as $row) {	
					// Fill the edit row with each attributes.
					foreach($row as $key => $value) {
							if(!$value) continue;
							$element = isset($element_map[$key])? $element_map[$key] : $key;
							if($key == 'stock_id')
								$steps[]= new When('I select "'.$value.'" from "'.$element.'"');
							else
								$steps[]= new When('I fill in "'.$element.'" with "'.$value.'"');
					}
					// Submit the row
					$steps[]= new Then('I press "Add Item"');
						 
				}
				return $steps;
		}


		/**
		 * @When /^I wait (\d+) seconds?$/
		 */
		public function iWaitSeconds($timeout) {
			$this->getSession()->wait($timeout*1000);
		}

    /**
     * @Then /^I should have the following quantity on hands:$/
     */
    public function iShouldHaveTheFollowingQuantityOnHands(TableNode $table)
    {
			$current_date = null;
			foreach($table->getHash() as $row) {                          
				$qoh = get_qoh_on_date($row['stock_id']);//, $row['location'], $current_date);
				assertEquals($row['quantity'], $qoh, "Error : ".implode($row, ', '));
			}
			
    }


		/**
		 * @Then /^I should have on the Journal View:$/
		 */
		public function iShouldHaveOnJournalView(TableNode $table)
		{
			/* We check table is exactly the same as the html one,
			 * including the header.
			 */
			$html_table = $this->getsession()->getPage()->find('xpath', '/body//center[2]/table');
			assertTrue($html_table != null);
			foreach($table->getRows() as $i => $gl_line) {
				$row = $i+1;
				foreach($gl_line as $j => $value) {
					# find the value in html table
					$column = $j+1;
					$cell = $html_table->find('xpath', "//tr[$row]/td[$column]");
					assertEquals($cell->getText(), $value);
				}
			}

		}


    /**
     * @When /^I void the last "([^"]*)"$/
     */
    public function iVoid($trans_type)
    {
/*
		$this->visit('admin/void_transaction');
		$this->selectOption('filterType', $trans_type);
		$this->pressButton('Search');
		$this->getSession()->wait('1000');
		$this->pressButton('1');
*/

			global $systypes_array;
			$flipped_types = array_flip($systypes_array);	
			$today = Today();
			void_transaction($flipped_types[$trans_type], 1, $today, '');
    }


    /**
     * @When /^I fill in or select the following:$/
     */
    public function iFillInOrSelectTheFollowing(TableNode $fields)
    {
        foreach ($fields->getRowsHash() as $locator => $value) {
        $locator = $this->fixStepArgument($locator);
        $value = $this->fixStepArgument($value);
					$field = $this->getSession()->getPage()->findField($locator);
					if($field->getTagName() == 'select')
						$field->selectOption($value);
					else // normal
						$field->setValue($value);

					

        }
    }



}

