xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace session="http://exist-db.org/xquery/session";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)

let $agenda := "/exist/tullio/newlogger/hello3.xql"
let $editor := "/exist/tullio/editor/editorH.html"
let $translate := "/exist/tullio/editor/editorH.html?t=yes"
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
		<td class="meeting-id "><span class="id">{$meet}</span>
		
		{
			if (string($id) != "") then <a class="reLog" href="{concat('/exist/tullio/newlogger/logger.html', '?m=', $meet, '&amp;lang=', $lang)}" >re-log</a> else ()
		}
		
		</td>
		<td class=" "><a href="{concat($agenda, '?m=', $meet)}">agenda</a></td>
		<!--
		<td class="meeting-id "><a href="{concat($logger, '?m=', $meet, '&amp;lang=', $lang)}">log</a></td>
		-->
		<td class=" ">
		{
			if (string($id) = "") then <td class="meeting-id "><a href="{concat($logger, '?m=', $meet, '&amp;lang=', $lang)}">log</a></td> else ()
		}
		</td>
		<!--
		<td class="meeting-id ">
		{
			if (string($id) = "") then () else <a href="{concat($status, '?m=', $meet, '&amp;lang=', $lang)}">statuspage</a>
		}	
		</td>
		-->
		<td class=" ">
		{
			if (string($id) = "") then () else <a href="{concat($editor, '?m=', $meet, '&amp;lang=', $lang)}">edit</a>
		}
		</td>
		<td class=" ">
		{
			if (string($id) = "") then () else 		<a href="{concat($translate, '&amp;m=', $meet, '&amp;lang=', $lang)}">translate</a>
		}
		</td>
		<td class=" ">
		{
			if (string($id) = "") then () else 		<a href="{concat($assemblage, '?m=', $meet, '&amp;lang=', $lang)}">assemblage</a>
		}
		
		</td>
	</tr>
}
</table>
