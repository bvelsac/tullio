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
let $entries := request:get-parameter("entries", ())            (: number -- id of stop event -- included :)


(: This script processes data sent after a clip edit -- the system can assume that the meeting and the clip id does already exist, otherwise the user would not have been able to edit the clip text
=> not true...
:)

(: status update will be passed as a part of the text body :)

let $nodes := util:eval( $entries ) 

(: update the correct document... :)

(: simply replace all text nodes with id between or equal to start and stop :) 

let $setuser := xdb:login("/db", "admin", "paris305")
(: let $style := <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="xml"/><xsl:variable name="number" select="wrapper/@n"/><xsl:template match="/"> <wrapper>     <xsl:apply-templates select="wrapper/*"/>   </wrapper> </xsl:template> <xsl:template match="*">   <xsl:copy><xsl:attribute name="c">        <xsl:value-of select="$number"/>      </xsl:attribute>   <xsl:copy-of select="text()"/>  </xsl:copy> </xsl:template></xsl:stylesheet> :)

      				
				
(: select the correct document :)

(: let $events-doc := concat("/db/tullio/", $meeting, '/events.xml') :)

let $events := transform:transform($nodes, "../xsl/logger2events.xsl", ())


let $stored := xdb:store(concat("/db/tullio/", $meeting), "events.xml", $events)


let $locks := <locks meeting="{$meeting}"></locks>

let $stored2 := xdb:store(concat("/db/tullio/", $meeting), "locks.xml", $locks)

let $descr := <meeting>{concat(substring-before($meeting, '-'), substring-before(substring-after($meeting, '-'), '-'), substring-before(substring-after(substring-after($meeting, '-'), '-'), '-'))}</meeting>

let $addDescr := update insert $descr into doc(concat("/db/tullio/", $meeting, '/', "events.xml"))/events

(:

let $point := doc($text-doc)//p[@c='0']


let $sec := if ($point is $point) then update insert $nice/p preceding $point else ()




let $first := doc($text-doc)//p[@c <= $stop and @c >=$start][1]



  

for $p in doc($text-doc)//p[@c <= $stop and @c >=$start]
  let $update := if ($p is $first) then update insert $nice/p preceding $p else ()
	let $delete := update delete $p
:)

(: return a success message :)

return 
<html>
<head></head>

<body>{$events}</body>

</html>
 

