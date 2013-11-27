xquery version "1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace request="http://exist-db.org/xquery/request";

declare option output:method "xml";
declare option output:media-type "application/xml";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

(: let $serverAddress:= "http://192.168.25.253:8080" :)

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)


let $target := request:get-parameter("target", ())

let $att := concat('use-for-', $target)


return

<events>{
for $pres in doc(concat($serverAddress, "/exist/tullio/xml/events.xml"))//event[@*[local-name()=$att] = 'y']
order by $pres/@order
return $pres}</events>
