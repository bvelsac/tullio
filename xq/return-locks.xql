xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= "http://http://192.168.25.253:8080"

let $meeting-id := request:get-parameter("m", ())
let $locks-doc := concat("/db/tullio/", $meeting-id, "/locks.xml")


let $locks := doc($locks-doc)//lock

let $s := doc($locks-doc)//s[@a='y']

return
<locks>{$locks,$s}</locks>
		

