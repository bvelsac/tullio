xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


let $meeting-id := request:get-parameter("m", ())
let $events-doc := concat("/db/tullio/", $meeting-id, "/events.xml")
let $text-doc := concat("/db/tullio/", $meeting-id, "/text.xml")
let $start :=  request:get-parameter("start", ())
let $stop :=  request:get-parameter("stop", ())

(: let $stringdata := "<fitzgerald/>" :)





let $events := if ($start and $stop) then <events>{doc($events-doc)//e[@n <= $stop and @n >= $start]}</events>
	else doc($events-doc)
		
let $type := $events//e[string(@n)=$start]/preceding-sibling::*[contains(@type, 'VVGGC') or contains(@type, 'BHP')][1]		

(: let $completed :=  transform:transform($events, "addclipref.xsl", ()) :)

(: for $clip in $completed//e[@c='y'] :)

(: let $events := $completed//e[@clip=$clip/@n] :)

let $texts := if ($start and $stop) then <doc>{doc($text-doc)//p[@c <= $stop and @c >= $start]}</doc>
	else doc($text-doc)
	 
(: doc(concat("/db/tullio/", $meeting-id, "/text.xml")) :)

return

<all><type>{$type}</type>{$events,$texts}</all>
		

