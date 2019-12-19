component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {

    property name="parser" inject="@cbyaml";

    variables.tempFilePath = expandPath( "/tests/resources/sample-files/sample.yml" );
    variables.travisYmlSamplePath = expandPath( "/tests/resources/sample-files/.travis.sample.yml" );

    function run() {
        describe( "Yaml Parser", function() {
            it( "can activate the module", function() {
                expect( getController().getModuleService().isModuleRegistered( "cbyaml" ) ).toBeTrue();
            } );

            describe( "Parser", function() {
                it( "can deserialize yaml strings", function() {
                    var travisYmlSample = fileRead( variables.travisYmlSamplePath );
                    var actual = parser.deserialize( travisYmlSample );
                    expect( actual ).toBe( getTravisYmlAsCF() );
                } );

                it( "can deserialize yaml files", function() {
                    var actual = parser.deserializeFile( variables.travisYmlSamplePath );
                    expect( actual ).toBe( getTravisYmlAsCF() );
                } );

                it( "can serialize yaml strings", function() {
                    var actual = parser.serialize( getTravisYmlAsCF() );
                    expect( parser.deserialize( actual ) ).toBe( getTravisYmlAsCF() );
                } );

                it( "can serialize yaml files", function() {
                    if ( fileExists( variables.tempFilePath ) ) {
                        fileDelete( variables.tempFilePath );
                    }

                    parser.serializeToFile( getTravisYmlAsCF(), variables.tempFilePath );
                    expect( parser.deserializeFile( variables.tempFilePath ) ).toBe( getTravisYmlAsCF() );
                } );
            } );

            describe( "Helpers", function() {
                it( "can use the global deserialize helper in a handler", function() {
                    getRequestContext().setValue( "body", fileRead( variables.travisYmlSamplePath ) );
                    var event = execute( "main.deserialize" );

                    expect( event.getRenderData().data ).toBe( getTravisYmlAsCF() );
                } );

                it( "can mix in the deserialize helper to a model", function() {
                    getRequestContext().setValue( "body", fileRead( variables.travisYmlSamplePath ) );
                    var event = execute( "main.deserializeWithModel" );

                    expect( event.getRenderData().data ).toBe( getTravisYmlAsCF() );
                } );

                it( "can use the global serialize helper in a handler", function() {
                    getRequestContext().setValue( "body", serializeJSON( getTravisYmlAsCF() ) );
                    var event = execute( "main.serialize" );

                    expect( parser.deserialize( event.getRenderData().data ) ).toBe( getTravisYmlAsCF() );
                } );

                it( "can mix in the serialize helper to a model", function() {
                    getRequestContext().setValue( "body", serializeJSON( getTravisYmlAsCF() ) );
                    var event = execute( "main.serializeWithModel" );

                    expect( parser.deserialize( event.getRenderData().data ) ).toBe( getTravisYmlAsCF() );
                } );
            } );
        } );
    }

    function getTravisYmlAsCF( asLinkedHashMap = false ) {
        return {
            "language": "java",
            "sudo": "required",
            "jdk": [ "openjdk8" ],
            "cache": {
                "directories": [ "$HOME/.CommandBox" ]
            },
            "env": {
                "matrix": [
                    "ENGINE=lucee@4.5",
                    "ENGINE=lucee@5",
                    "ENGINE=adobe@2018",
                    "ENGINE=adobe@2016",
                    "ENGINE=adobe@11"
                ]
            },
            "before_install": [
                "sudo apt-key adv --keyserver keys.gnupg.net --recv 6DA70622",
                'sudo echo "deb http://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list'
            ],
            "install": [
                "sudo apt-get update && sudo apt-get --assume-yes install commandbox",
                "box install"
            ],
            "before_script": [
                "box server start cfengine=$ENGINE port=8500"
            ],
            "script": [
                "box testbox run runner='http://127.0.0.1:8500/tests/runner.cfm'"
            ],
            "notifications": {
                "email": false
            },
            "testkey":7
        };
    }

}
