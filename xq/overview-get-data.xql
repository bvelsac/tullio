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
order by string($meet) descending
return 

<table id='overview'>
{
for $meet in xmldb:get-child-collections("/db/tullio/")
	let $logfile := document(concat("/db/tullio/", $meet, "/events.xml"))
	let $statusfile := document(concat("/db/tullio/", $meet, "/locks.xml"))
	
	
	
	
	return


	<table>
	<tr class="lang-N">
	<td>{$meet}</td>
	<td class="orig-EC">
	{
	 count($statusfile//s[@a="y"][@v="orig"][@val="EC"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	<td class="orig-T">
	{
	 count($statusfile//s[@a="y"][@v="orig"][@val="T"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	<td class="orig-R">
	{
	 count($statusfile//s[@a="y"][@v="orig"][@val="R"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	<td class="orig-V">
	{
	 count($statusfile//s[@a="y"][@v="orig"][@val="V"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	<td class="orig-A">
	{
	 count($statusfile//s[@a="y"][@v="orig"][@val="A"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	<td class="trans-T">
	{
	 count($statusfile//s[@a="y"][@v="trans"][@val="T"][@n=$logfile/events/e[@c="true"][@lang="F"]/@n])
	}
	
	</td>
	
	
	
	</tr>
	
	
	</table>
	
	}
	</table>
