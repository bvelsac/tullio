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
				


let $meeting := request:get-parameter("m", ())      (:string:)
let $clip := request:get-parameter("n", ())            (:number:)
let $version := request:get-parameter("v", ())         (:string -- 'orig' or 'trans' :)
let $person := request:get-parameter("id", ())          (: string  :)
let $force := request:get-parameter("force", ())          (: string  :)

(: This script processes data sent after a clip edit -- the system can assume that the meeting and the clip id does already exist, otherwise the user would not have been able to edit the clip text
=> not true...
:)
(:
let $lock := <lock n="{$clip}" v="{$version}" id="{$person}" time="{$time}"/>
:)
let $setuser := xdb:login("/db", "admin", "paris305")

(:
let $style := <!DOCTYPE stylesheet [
<!ENTITY ntilde  "&#241;" ><!-- small n, tilde -->
]><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="xml"/><xsl:variable name="number" select="wrapper/@n"/><xsl:template match="/"> <wrapper>     <xsl:apply-templates select="wrapper/*"/>   </wrapper> </xsl:template> <xsl:template match="*">   <xsl:copy><xsl:attribute name="c">        <xsl:value-of select="$number"/>      </xsl:attribute>   <xsl:copy-of select="text()"/>  </xsl:copy> </xsl:template></xsl:stylesheet>
:)
      				
				
(: select the correct document :)

(: let $doc := if ($category="orig") then "/text.xml" else "/translations.xml" :)

let $doc := "/locks.xml"
let $locks-doc := concat("/db/tullio/", $meeting, $doc)
(: let $point := doc($locks-doc)/locks :)
let $result := if (doc($locks-doc)//lock[@n=$clip][@v=$version][@id=$person]) then (update delete doc($locks-doc)//lock[@n=$clip][@v=$version][@id=$person], <p>success unlocked {$clip} - {$version}</p>) 
	else if ($force = 'true' and doc($locks-doc)//lock[@n=$clip][@v=$version]) then (update delete doc($locks-doc)//lock[@n=$clip][@v=$version], <p>success unlocked {$clip} - {$version}</p>)
	else <p>not found</p>



(: return a success message :)

return 
<html>
<head></head>

<body>{$result}</body>

</html>
 

