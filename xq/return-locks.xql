xquery version "1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace request="http://exist-db.org/xquery/request";

declare option output:method "xml";
declare option output:media-type "application/xml";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)

let $meeting-id := request:get-parameter("m", ())
let $locks-doc := concat("/db/tullio/", $meeting-id, "/locks.xml")


let $locks := doc($locks-doc)//lock

let $s := doc($locks-doc)//s[@a]

return
<locks>{$locks,$s}</locks>
		

