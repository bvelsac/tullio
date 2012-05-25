xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


let $meeting-id := request:get-parameter("m", ())
let $events-doc := concat("/db/tullio/", $meeting-id, "/events.xml")
let $agenda-doc := concat("/db/tullio/", $meeting-id, "/agenda.xml")
let $text-doc := concat("/db/tullio/", $meeting-id, "/text.xml")
let $trans1-doc := concat("/db/tullio/", $meeting-id, "/trans1.xml")
let $start :=   request:get-parameter("start", ()) 
let $stop := request:get-parameter("stop", ()) 
let $joinTrans := request:get-parameter("include", ())
let $toFinish := request:get-parameter("bottom", ())

let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()
let $stopAsDec := if (string($toFinish)) then xs:decimal(doc($events-doc)//e[position()=last()]/@n) + 1 else if ($stop) then xs:decimal(normalize-space($stop)) else ()

(: let $stringdata := "<fitzgerald/>" :)

(: let $events := if ($startAsDec and $stopAsDec) then <events>{doc($events-doc)//e[@n <= $stopAsDec and @n >= $startAsDec]}</events>
	else doc($events-doc)
:)
		
let $stopRow := doc($events-doc)//e[@n = $stopAsDec]
let $next := $stopRow/following-sibling::*[@c='true'][1]

let $nextAlways := if ($next) then xs:decimal($next/@n) else if (string($stop)) then xs:decimal($stopAsDec + 2) else xs:decimal(doc($events-doc)//e[position()=last()]/@n +2)

(: let $corrStop :=  if doc($events-doc)//e[@n = $stop][@c='y']/following-sibling::e[@c='y'] then  :)


let $events := if ($startAsDec and $stopAsDec) then <events>{doc($events-doc)//e[@n < $nextAlways and @n >= $startAsDec], doc($events-doc)//meeting}</events>
	else doc($events-doc)

let $type := if (doc($agenda-doc)/xml/type = 'PLEN') then doc($events-doc)//e[string(@n)=$start]/preceding-sibling::*[@type='O-BXL' or @type='O-ARVV' or @type='HERV-ARVV' or @type='HERV-BXL'][1] else doc($agenda-doc)/xml/type

let $info := doc($agenda-doc)/xml/info

let $presEvent := doc($events-doc)//e[string(@n)=$start]/preceding-sibling::*[@type='PRES' or @type='PRES-CH'][1]
(: let $completed :=  transform:transform($events, "addclipref.xsl", ()) 

:)


(: for $clip in $completed//e[@c='y'] :)

(: let $events := $completed//e[@clip=$clip/@n] :)

let $texts := if ($startAsDec and $stopAsDec) then <doc>{doc($text-doc)//p[@c <= $stopAsDec and @c >= $startAsDec]}</doc>
	else doc($text-doc)
		
let $trans1 := if ($joinTrans) then 
		if ($startAsDec and $stopAsDec) then <trans n="1">{doc($trans1-doc)//p[@c <= $stopAsDec and @c >= $startAsDec]}</trans>
		else <trans n="1">{doc($trans1-doc)//p}</trans>
	else ()
	 
let $locks-doc := concat("/db/tullio/", $meeting-id, "/locks.xml")		
let $s := if ($startAsDec and $stopAsDec) then <locks>{doc($locks-doc)//s[@a='y'][@n <= $stopAsDec and @n >= $startAsDec]}</locks> else <locks>{doc($locks-doc)//s[@a='y']}</locks>
		
(: doc(concat("/db/tullio/", $meeting-id, "/text.xml")) :)

return

<all>{$info, <variables><type>{$type}</type><pres>{string($presEvent/@speaker)}</pres><next>{string($nextAlways)}</next><nextTimeCode>{$next/@time}</nextTimeCode></variables>, <meta>{$startAsDec, $stop}</meta>,
$events,$texts, $trans1,$s}
</all>

