/**
 * Resstart an embedded CFML server.  Run command from the web root of the server or use
 * the 'directory' and/or 'name' arguments.
 * .
 * {code:bash}
 * server restart
 * server restart myapp
 * {code}
 **/
component aliases="restart" {

	// DI
	property name="serverService" 	inject="ServerService";
	property name="packageService" 	inject="packageService";

	/**
	 * @name.hint the short name of the server
	 * @name.optionsUDF serverNameComplete
	 * @directory.hint web root for the server
	 * @serverConfigFile The path to the server's JSON file.
	 * @force.hint if passed, this will force restart the server
	 * @openbrowser.hint open a browser after restarting, defaults to false
	 **/
	function run(
		string name,
		string directory,
		String serverConfigFile,
		boolean force=false,
		boolean openBrowser=false
	){
		if( !isNull( arguments.directory ) ) {
			arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		} 
		if( !isNull( arguments.serverConfigFile ) ) {
			arguments.serverConfigFile = fileSystemUtil.resolvePath( arguments.serverConfigFile );
		}		
		var serverDetails = serverService.resolveServerDetails( arguments );
		var serverInfo = serverDetails.serverInfo;

		// Verify server info
		if( serverDetails.serverIsNew ){
			error( "The server you requested was not found.", "You can use the 'server list' command to get all the available servers." );
		}

		var stopCommand = "server stop '#serverInfo.name#'";
		var startCommand = "server start name='#serverInfo.name#' port=#serverInfo.port# openBrowser=#arguments.openBrowser# --!saveSettings";

		// stop server
		print.boldCyanLine( "Trying to stop server..." );
		print.yellowLine( '> ' & stopCommand );
		runCommand( stopCommand );
		
		// start up server
		print.line().boldCyanLine( "Trying to start server..." );
		print.yellowLine( '> ' & startCommand );
		runCommand( startCommand );
	}

	
	function serverNameComplete() {
		return serverService.getServerNames();
	}
}