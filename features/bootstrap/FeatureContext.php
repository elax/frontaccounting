<?php

use Behat\Behat\Context\ClosuredContextInterface,
    Behat\Behat\Context\TranslatedContextInterface,
    Behat\Behat\Context\BehatContext,
    Behat\Behat\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode,
    Behat\Gherkin\Node\TableNode;

//
// Require 3rd-party libraries here:
//
//   require_once 'PHPUnit/Autoload.php';
//require_once 'PHPUnit/Framework/Assert/Functions.php';
//

require_once('features/bootstrap/init_connection.inc');

require_once('gl/includes/db/gl_db_trans.inc');

/**
 * Features context.
 */
class FeatureContext extends BehatContext
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
	 * @Transform /(\d+\.\d+)/
	 */
		public function stringToFload($string) {
			return floatval($string);
		}

		public static function setConnection() {
			self::$db_connection = init_db_connection();
                                        
			self::restore_db('en_US-new.sql', self::$db_connection);
			
			return  self::$db_connection;

		}


	public static function restore_db($backup_name=null) {
		if(!is_null($backup_name)) {
			self::$backup_name = $backup_name;
		}

		return db_import("features/fixtures/$backup_name", self::$db_connection);
	}


		/**
		 *  @Given /^I have a COA$/
		 */
		public function iHaveACoa()
		{
			$db = $this->setConnection();
			if(is_null($db))
				throw new Exception('not database');
		
			//throw new PendingException();
		}

		/**
		 * @When /^I post a (\d+\.\d+) to account (\d+)$/
		 */
		public function iPostAToAccount($amount, $account)
		{

			$type = ST_JOURNAL;
			$trans_id = 1;
			$date = '2013/12/01';
			add_gl_trans($type, $trans_id, $date, $account, null, null, "", $amount);
		}

		/**
		 * @Then /^the GL transaction should includes:$/
		 */
		public function theGlTransactionShouldIncludes(TableNode $table)
		{
			throw new PendingException();
		}

}

