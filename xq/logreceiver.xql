xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
				

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)



let $meeting := request:get-parameter("m", ())      (:string:)
let $entries := request:get-data()            (: number -- id of stop event -- included :)
let $nodes :=  $entries
let $setuser := xdb:login("/db", "admin", "paris305")

let $descr := <meeting>{concat(substring-before($meeting, '-'), substring-before(substring-after($meeting, '-'), '-'), substring-before(substring-after(substring-after($meeting, '-'), '-'), '-'))}</meeting> 

let $eventfile := concat("/db/tullio/", $meeting, "/events.xml")
let $textfile := concat("/db/tullio/", $meeting, "/text.xml")
let $translations := concat("/db/tullio/", $meeting, "/trans1.xml")
let $id := util:document-id($eventfile)

(: create the new collection for this meeting :)

let $collection := concat("/db/tullio/", string($meeting))

let $check := if ( not( xmldb:collection-exists($collection) ) )
   then xmldb:create-collection("/", $collection)
   else ()

(: look up the highest number of existing events :)
let $max := if (string($id) = "") then 102 else xs:decimal(doc($eventfile)//e[position()=last()]/@n) + 2

(: do not overwrite existing text, divide max by 2 for stylesheet since it uses doubles and doubles - 1 for markers :)
(: next one is server return for the grid update :)
let $output := transform:transform($nodes, "../xsl/logfeedback.xsl", <parameters><param name="lower" value="{$max div 2}"/></parameters>)

(: next one is what will be stored in the db :)
let $events := transform:transform($nodes, "../xsl/logreceiver.xsl", <parameters><param name="lower" value="{$max div 2}"/></parameters>)

(: store the output in the db, just append it to the existing events since the client only submits dirty (new) rows :)

let $stored := if ($max = 102) then (xdb:store(concat("/db/tullio/", $meeting), "events.xml", $events//events), update insert $descr into doc($eventfile)/events) else if ($events//events/e) then update insert $events//events/e into doc($eventfile)/events else ()

(:  run transformation to store formatted events in db

let $titles := doc(concat($serverAddress, "/exist/tullio/xml/titles.xml"))
let $intermediate := transform:transform($events//events, "../editor/xsl/addclipref.xsl", ())

let $debug := xdb:store(concat("/db/tullio/", $meeting), "test.xml", <h>{$intermediate}</h>)

let $initClips := transform:transform(<container>{$intermediate,$titles}</container>, "../editor/xsl/group.xsl", <parameters><param name="server" value="yes"/></parameters>)

let $storedClips := if ($max = 102) then xdb:store(concat("/db/tullio/", $meeting), "text.xml", <doc>{$initClips//original/p}</doc>) else if ($initClips//original/p) then update insert $initClips//original/p into doc($textfile)/doc else()
 :)
(: store simple placeholders for translations

let $trans := for $e in $events/xmlData/events/e return <p title='{$e/@n}' class='init' />

let $storedTrans := if ($max = 102) then xdb:store(concat("/db/tullio/", $meeting), "trans1.xml", <doc>{$trans}</doc>) else if ($trans/p) then update insert $trans/p into doc($textfile)/doc else()
 :)
 
let $initClips := for $e in $events//e[@c='true'] return <p c="{$e/@n}"  class="init">(clip {string($e/@n)})</p>
			

let $storedClips := if ($max = 102) then xdb:store(concat("/db/tullio/", $meeting), "text.xml", <doc>{$initClips}</doc>) else if ($initClips) then update insert $initClips into doc($textfile)/doc else()
 

let $storedClips := if ($max = 102) then xdb:store(concat("/db/tullio/", $meeting), "trans1.xml", <trans n="1">{$initClips}</trans>) else if ($initClips) then update insert $initClips into doc($translations)/trans else()
 
 
let $locks := if ($max = 102) then xdb:store(concat("/db/tullio/", $meeting), "locks.xml", <locks meeting="{$meeting}"></locks>) else ()


return 
 
$output
