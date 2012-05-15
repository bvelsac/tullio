xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)


let $meeting-id := request:get-parameter("m", ())
let $events-doc := concat("/db/tullio/", $meeting-id, "/events.xml")
let $start :=   request:get-parameter("start", ()) 

let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()

let $presEvent := doc($events-doc)//e[@n=$start]/preceding-sibling::e[@type='PRES' or @type='PRES-CH'][1]
let $pres := doc(concat($serverAddress, "/exist/tullio/xml/titles.xml"))//person[@id=$presEvent/@speaker]


(: let $pres := doc($events-doc)//e[@n <= $startAsDec][@type='pres'][position()=last()] :)
let $type :=  doc($events-doc)//e[string(@n)=$start]/preceding-sibling::*[contains(@type, 'VVGGC') or contains(@type, 'BHP')][1]/@type



return

<info><type>{$type}</type><pres>{$pres}</pres></info>
		

