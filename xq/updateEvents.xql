xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $meeting := request:get-parameter("m", ())      (:string:)
let $events := request:get-parameter("events", ())            (:elements:)
let $start := request:get-parameter("start", ())          (: number -- id of start event -- included :)
let $stop := request:get-parameter("stop", ())            (: number -- id of stop event -- included :)

let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()
let $stopAsDec := if ($stop) then xs:decimal(normalize-space($stop)) else ()

let $nodes := if ($events) then util:eval( $events ) else ()

let $setuser := xdb:login("/db", "admin", "paris305")
let $doc := "/events.xml"
let $events-doc := concat("/db/tullio/", $meeting, $doc)

let $op := util:random()
let $clumsy := <e marker='invalid' id='{$op}'/>
let $atts := $clumsy/@* 

let $touch := doc($events-doc)//e[@n <= $stopAsDec and @n >=$startAsDec]
let $list := for $x in $touch return $x/@n cast as xs:string

let $update := if ($nodes) then (update insert $atts into $touch, update insert $nodes preceding $touch[1], update delete doc($events-doc)//e[@id=$op][@marker='invalid']) else ()

return 
<body><div>these nodes were updated:
{$list}
</div>
<div>
success {$start, $stop, $events-doc}
</div>
</body>
