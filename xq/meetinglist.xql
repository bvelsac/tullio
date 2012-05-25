xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace session="http://exist-db.org/xquery/session";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)
let $lang := session:get-attribute('lang')

return 

<list>
  {
for $meet in xmldb:get-child-collections("/db/tullio/")
	let $logfile := concat("/db/tullio/", $meet, "/events.xml")
	let $id := util:document-id($logfile)
	let $status := if (string($id) = "") then "scheduled" else ()
	let $logger := if (string($id) = "") then "/exist/tullio/newlogger/logger.html" else "checklog.xql"
	order by string($meet) descending
	return 
<item>{$meet}</item>
  }
</list>
