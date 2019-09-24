component extends="coldbox.system.EventHandler" {

	// Default Action
	function index(event,rc,prc){
		prc.welcomeMessage = "Welcome to ColdBox!";
		event.setView("main/index");
	}
	// Do something
	function doSomething(event,rc,prc){
		setNextEvent("main.index");
    }

    function deserialize( event, rc, prc ) {
        event.renderData( type = "json", data = deserializeYaml( rc.body ) );
    }

    function deserializeWithModel( event, rc, prc ) {
        var modelWithParserHelpers = getInstance( "app.models.ModelWithParserHelpers" );
        event.renderData( type = "json", data = modelWithParserHelpers.parse( rc.body ) );
    }

    function serialize( event, rc, prc ) {
        event.renderData( type = "json", data = serializeYaml( deserializeJSON( rc.body ) ) );
    }

    function serializeWithModel( event, rc, prc ) {
        var modelWithParserHelpers = getInstance( "app.models.ModelWithParserHelpers" );
        event.renderData( type = "json", data = modelWithParserHelpers.stringify( deserializeJSON( rc.body ) ) );
    }

	/************************************** IMPLICIT ACTIONS *********************************************/
	function onAppInit(event,rc,prc){
	}
	function onRequestStart(event,rc,prc){
	}
	function onRequestEnd(event,rc,prc){
	}
	function onSessionStart(event,rc,prc){
	}
	function onSessionEnd(event,rc,prc){
		var sessionScope = event.getValue("sessionReference");
		var applicationScope = event.getValue("applicationReference");
	}
	function onException(event,rc,prc){
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:
	}
	function onMissingTemplate(event,rc,prc){
		//Grab missingTemplate From request collection, placed by ColdBox
		var missingTemplate = event.getValue("missingTemplate");
	}
}
