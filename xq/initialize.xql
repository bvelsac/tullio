xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

(:

let $setuser := xdb:login("/db", "admin", "paris305")
        let $confCol := (
            xdb:create-collection("/db/test", "lookspaghetti")
        )

:)

let $meeting := request:get-parameter("meeting", ())      (:string:)

(: This script processes data sent after a clip edit -- the system can assume that the meeting and the clip id does already exist, otherwise the user would not have been able to edit the clip text
=> not true...
:)

(: status update will be passed as a part of the text body :)

(: update the correct document... :)

(: simply replace all text nodes with id between or equal to start and stop :) 

let $setuser := xdb:login("/db", "admin", "paris305")
let $coll := concat("/db/tullio/", $meeting)

let $textfile := concat("/db/tullio/", $meeting, "/text.xml")
let $transfile := concat("/db/tullio/", $meeting, "/trans1.xml")
let $id := util:document-id($textfile)

return if (string($id) = "") then 

	let $events := doc(concat($coll, '/events.xml'))
	let $titles := doc('../xml/titles.xml')
	
	let $completed :=  <events>{transform:transform(<all>{$events}</all>, "../editor/xsl/addclipref.xsl", ()), $titles/reference}</events>
	
	
	let $nice := transform:transform($completed, "../editor/xsl/initialize.xsl", ())      		
				
	(: select the correct document :)

	let $confStored := xdb:store($coll, "text.xml", $nice)

	let $some := <trans n="1">{
		for $e in $events//e[@c='true'] return 
			<p c="{$e/@n}"  class="init">vertaling</p>
			}
			</trans>
	let $confStored2 := xdb:store($coll, "trans1.xml", $some)

	(: return a success message :)

	return <html>
		<head></head>
		<body>{$nice, $completed}</body>
		</html>
 
else 	<html>
	<head></head>
	<body>Existing transcript</body>
	</html>

