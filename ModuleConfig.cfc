component {

    this.name = "cbyaml";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cbyaml";
    this.cfmapping = "cbyaml";
    this.dependencies = [ "cbjavaloader" ];

    function configure() {
        settings = {
            "autoLoadHelpers": true
        };
    }

	function onLoad() {
		wirebox.getInstance( "loader@cbjavaloader" )
            .appendPaths( variables.modulePath & "/lib" );

        if ( structKeyExists( variables, "controller" ) && settings.autoLoadHelpers ) {
            var helpers = controller.getSetting( "applicationHelper" );
            arrayAppend(
                helpers,
                "#moduleMapping#/helpers.cfm"
            );
            controller.setSetting( "applicationHelper", helpers );
        }
    }

    function onUnload() {
        if( structKeyExists( variables, "controller" ) ){
	    controller.setSetting(
                "applicationHelper",
                arrayFilter( controller.getSetting( "applicationHelper" ), function( helper ) {
                    return helper != "#moduleMapping#/helpers.cfm";
                } )
            );
	}
    }

}
