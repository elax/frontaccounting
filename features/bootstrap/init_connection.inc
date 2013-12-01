#!/usr/bin/php
<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/

$path_to_root = ".";

require_once('features/bootstrap/config.inc');
require_once($path_to_root.'/installed_extensions.php');

error_reporting(-1);

include_once($path_to_root.'/includes/main.inc');
include_once($path_to_root . "/includes/ajax.inc");

// Ajax communication object
$Ajax = new Ajax();
// js/php validation rules container
$Validate = array();
// bindings for editors
$Editors = array();
// page help. Currently help for function keys.
$Pagehelp = array();

$Refs = new references();

function display_notification($msg)
{
	echo $msg."\n";
};

function display_error($msg)
{
	error_log($msg);
};

include_once($path_to_root.'/includes/hooks.inc');
include_once($path_to_root.'/admin/db/company_db.inc');
include_once($path_to_root.'/includes/prefs/sysprefs.inc');
require_once($path_to_root.'/lang/installed_languages.inc');
require_once($path_to_root.'/includes/db/connect_db.inc');
require_once($path_to_root.'/includes/db/sql_functions.inc');
require_once($path_to_root.'/admin/db/users_db.inc');
require_once($path_to_root.'/admin/db/maintenance_db.inc');
require_once($path_to_root.'/includes/current_user.inc');
require_once($path_to_root.'/includes/errors.inc');
require_once($path_to_root.'/includes/systypes.inc');
//require_once($path_to_root.'/includes/sysnames.inc');
require_once($path_to_root.'/includes/types.inc');

//include_once($path_to_root . "/includes/session.inc");
if (!isset($_SESSION["wa_current_user"]))
	$_SESSION["wa_current_user"] = new current_user();

function init_db_connection() {
	global $db_connections, $def_coy;
	$def_coy = 0;
	$tb_pref_counter = 1;
	$db_connections = array (
		0 => 
		array (
			'name' => 'behat',
			'host' => 'localhost',
			'dbuser' => 'root',
			'dbpassword' => '',
			'dbname' => 'fa_behat',
			'tbpref' => '0_',
		),
	);
	set_global_connection($def_coy);
	$connection = $db_connections[$def_coy];
	db_create_db($connection);

	return $connection;

}
