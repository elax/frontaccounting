<?php

use Behat\Behat\Context\ClosuredContextInterface,
	Behat\Behat\Context\TranslatedContextInterface,
	Behat\Behat\Context\BehatContext,
	Behat\Behat\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode,
	Behat\Gherkin\Node\TableNode;

use Behat\Behat\Event\FeatureEvent;

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

}

