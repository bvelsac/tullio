xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= "http://192.168.25.253:8080"

let $target := request:get-parameter("target", ())

let $att := concat('use-for-', $target)


return

<events>{
for $pres in doc(concat($serverAddress, "/exist/tullio/xml/events.xml"))//event[@*[local-name()=$att] = 'y']
order by $pres/@order
return $pres}</events>
		

