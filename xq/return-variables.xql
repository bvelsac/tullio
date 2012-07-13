xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)


let $meeting-id := request:get-parameter("m", ())
let $events-doc := concat("/db/tullio/", $meeting-id, "/events.xml")
let $start :=   request:get-parameter("start", ()) 
let $meeting-type := request:get-parameter("mt", ())

let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()

let $presEvent := doc($events-doc)//e[@n=$start]/preceding-sibling::e[@type='PRES' or @type='PRES-CH'][1]
let $pres := doc(concat($serverAddress, "/exist/tullio/xml/titles.xml"))//person[@id=$presEvent/@speaker]


(: let $pres := doc($events-doc)//e[@n <= $startAsDec][@type='pres'][position()=last()] :)

let $final-meeting-type := 
	if  ( not($meeting-type = 'VAR') ) then $meeting-type
	else if (not($startAsDec)) then doc($events-doc)//e[@type='O-BXL' or @type='O-ARVV' or @type='HERV-ARVV' or @type='HERV-BXL'][1]/@type 
	else doc($events-doc)//e[@n = $startAsDec]/preceding-sibling::e[@type='O-BXL' or @type='O-ARVV' or @type='HERV-ARVV' or @type='HERV-BXL'][1]/@type


return

<info>
	<type>{$final-meeting-type}</type>
	<pres>{$pres}</pres>
	<next></next>	
	
</info>
		

