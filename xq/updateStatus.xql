xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $meeting := request:get-parameter("m", ())      (:string:)
let $clipid := request:get-parameter("id", ())          (: number -- id of start event -- included :)
let $cat := request:get-parameter("cat", ())
let $ts := request:get-parameter("ts", ())
let $val := request:get-parameter("val", ())
let $who := request:get-parameter("au", ())    



let $setuser := xdb:login("/db", "admin", "paris305")
let $lockfile := concat("/db/tullio/", $meeting, "/locks.xml")

let $one := for $s in doc($lockfile)//s[@n=$clipid] return  update delete $s/@a 


let $update := update insert <s a="y" n="{$clipid}" au="{$who}" val="{$val}" ts="{$ts}" v="{$cat}" />   into doc($lockfile)/locks 

return 
<body>
</body>


