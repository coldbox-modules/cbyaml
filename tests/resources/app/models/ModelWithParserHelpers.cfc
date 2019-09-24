component mixins="/cbyaml/helpers" {

    function parse( required string content ) {
        return deserializeYaml( arguments.content );
    }

    function stringify( required any content ) {
        return serializeYaml( arguments.content );
    }

}
