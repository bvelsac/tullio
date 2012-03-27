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



(: do not overwrite existing events, new clips may have been created :)

let $eventfile := concat("/db/tullio/", $meeting, "/events.xml")
let $textfile := concat("/db/tullio/", $meeting, "/text.xml")
let $id := util:document-id($eventfile)

let $max := if (string($id) = "") then 0 else xs:decimal(doc($eventfile)//e[position()=last()]/@n)

(: do not overwrite existing text :)

let $events := transform:transform($nodes, "../xsl/logger2events.xsl", <parameters><param name="lower" value="{$max div 2}"/></parameters>)

let $descr := <meeting>{concat(substring-before($meeting, '-'), substring-before(substring-after($meeting, '-'), '-'), substring-before(substring-after(substring-after($meeting, '-'), '-'), '-'))}</meeting> 

let $stored := if ($max = 0) then (xdb:store(concat("/db/tullio/", $meeting), "events.xml", $events), update insert $descr into doc($eventfile)/events) else if ($events//e) then update insert $events//e into doc($eventfile)/events else ()

let $intermediate := transform:transform($events, "../editor/xsl/addclipref.xsl", ())
let $initClips := transform:transform($intermediate, "../editor/xsl/group.xsl", <parameters><param name="server" value="yes"/></parameters>)

(: let $initClips := transform:transform(<wrapper>{$preClips}</wrapper>, "../editor/xsl/addInit.xsl", ()) :)

(: let $debug := xdb:store(concat("/db/tullio/", $meeting), "debug.xml", <wrapper>{$preClips}</wrapper>) :)

let $storedClips := if ($max = 0) then xdb:store(concat("/db/tullio/", $meeting), "text.xml", <doc>{$initClips//original/p}</doc>) else if ($initClips//original/p) then update insert $initClips//original/p into doc($textfile)/doc else()

let $storedTrans := if ($max = 0) then xdb:store(concat("/db/tullio/", $meeting), "trans1.xml", <doc>{$initClips//translation/p}</doc>) else if ($initClips//translation/p) then update insert $initClips//translation/p into doc($textfile)/doc else()


let $locks := if ($max = 0) then xdb:store(concat("/db/tullio/", $meeting), "locks.xml", <locks meeting="{$meeting}"></locks>) else ()

(: return a success message :)

return 
<html>
<head></head>

<body>{$events,$max}</body>

</html>
 

