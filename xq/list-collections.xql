xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


(: create the new collection for this meeting :)

let $logger := "../logger/html/Meeting-recorder-nv2.html"
let $editor := "../editor/editor-trans.html"
let $status := "../status/status.html"



return 

<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title>XQuery Form Example</title>
 </head>
<body>

<h3>Overzicht</h3>
<ul>
{
for $meet in xmldb:get-child-collections("/db/tullio/")
let $logfile := concat("/db/tullio/", $meet, "/events.xml")
let $id := util:document-id($logfile)
order by string($meet) descending
return if (string($id) = "") 
then <li><span class="meeting-id ">{$meet}</span><span class="log">&#160;<a href="{concat($logger, '?m=', $meet)}">Log</a></span><span class="log">&#160;<a href="{concat($status, '?m=', $meet)}">Status</a></span></li> 
else <li><span class="meeting-id">{$meet}</span><span class="log">&#160;<a href="{concat($editor, '?m=', $meet)}">Edit</a></span><span class="log">&#160;<a href="{concat($status, '?m=', $meet)}">Status</a></span></li>



}
</ul>
<h4>Of maak een <a href="../agenda/invoer-agenda2.html">nieuwe vergadering</a> aan.</h4>
</body>
</html>

