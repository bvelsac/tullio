xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)

let $agenda := "../agenda/checkagenda.html"

let $editor := "../editor/editor-trans2.html"
let $translate := "../editor/editor-trans2.html?t=yes"
let $status := "../status/status.html"
let $assemblage := "../assemblage/assemblage.html"


return 

<table id='overview'>
{
for $meet in xmldb:get-child-collections("/db/tullio/")
	let $logfile := concat("/db/tullio/", $meet, "/events.xml")
	let $id := util:document-id($logfile)
	let $status := if (string($id) = "") then "scheduled" else ()
	let $logger := if (string($id) = "") then "../newlogger/logger.html" else "checklog.xql"
	order by string($meet) descending
	return 
	<tr class='{$status}'>
		<td class="meeting-id ">{$meet}</td>
		<td class="meeting-id "><a href="{concat($agenda, '?m=', $meet)}">agenda</a></td>
		<td class="meeting-id "><a href="{concat($logger, '?m=', $meet)}">log</a></td>
		<td class="meeting-id "><a href="{concat($editor, '?m=', $meet)}">edit</a></td>
		<td class="meeting-id "><a href="{concat($translate, '&amp;m=', $meet)}">translate</a></td>
		<td class="meeting-id "><a href="{concat($assemblage, '?m=', $meet)}">assemblage</a></td>
	</tr>
}
</table>
