xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace session="http://exist-db.org/xquery/session";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)

let $agenda := "/exist/tullio/agenda/checkagenda.html"
let $editor := "/exist/tullio/editor/editor-trans2.html"
let $translate := "/exist/tullio/editor/editor-trans2.html?t=yes"
let $statuspage := "/exist/tullio/status/status.html"
let $assemblage := "/exist/tullio/assemblage/assemblage.html"

let $lang := session:get-attribute('lang')

return 

<table id='overview'>
{
for $meet in xmldb:get-child-collections("/db/tullio/")
	let $logfile := concat("/db/tullio/", $meet, "/events.xml")
	let $id := util:document-id($logfile)
	let $status := if (string($id) = "") then "scheduled" else ()
	let $logger := if (string($id) = "") then "/exist/tullio/newlogger/logger.html" else "checklog.xql"
	order by string($meet) descending
	return 
	<tr class='{$status}'>
		<td class="meeting-id ">{$meet}</td>
		<td class="meeting-id "><a href="{concat($agenda, '?m=', $meet)}">agenda</a></td>
		<td class="meeting-id "><a href="{concat($logger, '?m=', $meet, '&amp;lang=', $lang)}">log</a></td>
		<td class="meeting-id ">
		{
			if (string($id) = "") then () else <a href="{concat($status, '?m=', $meet, '&amp;lang=', $lang)}">statuspage</a>
		}	
		</td>
		<td class="meeting-id ">
		{
			if (string($id) = "") then () else <a href="{concat($editor, '?m=', $meet, '&amp;lang=', $lang)}">edit</a>
		}
		</td>
		<td class="meeting-id ">
		{
			if (string($id) = "") then () else 		<a href="{concat($translate, '&amp;m=', $meet, '&amp;lang=', $lang)}">translate</a>
		}
		</td>
		<td class="meeting-id ">
		{
			if (string($id) = "") then () else 		<a href="{concat($assemblage, '?m=', $meet, '&amp;lang=', $lang)}">assemblage</a>
		}
		
		</td>
	</tr>
}
</table>
