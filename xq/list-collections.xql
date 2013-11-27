xquery version "3.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace session="http://exist-db.org/xquery/session";

declare option output:method "xml";
declare option output:media-type "application/xml";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)

let $agenda := "/exist/tullio/newlogger/hello3.xql"
let $editor := "/exist/tullio/editor/editorH.html"
let $translate := "/exist/tullio/editor/editorH.html?t=yes"
let $statuspage := "/exist/tullio/status/status.html"
let $assemblage := "/exist/tullio/assemblage/assemblage.html"
let $dashboard := "/exist/tullio/dashboard/dashboard.html"

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
		<td class="viewAgenda "><a class="" href="{
		  if (xs:integer(translate(substring($meet, 1, 10), '-', '')) > 20130424) 
		  then concat ('/exist/rest//db/tullio/', $meet, '/agenda.xml?_xsl=/tullioxsl/agenda2log.xsl')
		  else concat($agenda, '?m=', $meet)
		}">agenda</a>
		{
			if (xs:integer(translate(substring($meet, 1, 10), '-', '')) > 20130424) then <a class="editAgenda" href="{concat('/exist/tullio/newagenda2/agenda.html', '?m=', $meet, '&amp;lang=', $lang)}" >&#x1F527;</a> else ()
		}
		
		</td>
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
		<td class=" ">
		{
			if (string($id) = "") then () else 		<a href="{concat($dashboard, '?m=', $meet, '&amp;lang=', $lang)}">o</a>
		}
		
		</td>
	</tr>
}
</table>
