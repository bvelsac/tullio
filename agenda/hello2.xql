xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $setuser := xdb:login("/db", "admin", "paris305")

let $meeting := request:get-parameter("m", ())      (:string:)
let $stringdata := request:get-data()

let $test := $stringdata 

(: create the new collection for this meeting :)

let $collection := concat("/db/tullio/", string($test//meeting))


let $check := if ( not( xmldb:collection-exists($collection) ) )
   then xmldb:create-collection("/", $collection)
   else ()

(: let $nice := transform:transform($test, "render.xsl", ())   :)

(: let $debug := xdb:store("/db/test", "abba.xml", <testDoc></testDoc>) :)

let $confStored := xdb:store($collection, "agenda.xml", $test)


return 
(
	<span>Data saved to collection {$collection}.</span>
	
)

