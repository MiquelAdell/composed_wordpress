define('FS_METHOD','direct');


if(getenv('DEBUG')){
	// Enable WP_DEBUG mode
	define( 'WP_DEBUG', true );

	// Enable Debug logging to the /wp-content/debug.log file
	define( 'WP_DEBUG_LOG', true );

	// Emable display of errors and warnings
	define( 'WP_DEBUG_DISPLAY', true );
	@error_reporting(E_ALL ^ E_NOTICE);

	// Use dev versions of core JS and CSS files (only needed if you are modifying these core files)
	define( 'SCRIPT_DEBUG', true );
}
