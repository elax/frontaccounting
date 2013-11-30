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
//   require_once 'PHPUnit/Framework/Assert/Functions.php';
//

$path_to_root = '.';

require_once('features/bootstrap/shell_tests.php');

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

		}
		/**
		 *  @Given /^I have a COA$/
		 */
		public function iHaveACoa()
		{
			$this->setConnection();
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

