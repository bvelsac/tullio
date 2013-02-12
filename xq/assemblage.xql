xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";


let $meeting-id := request:get-parameter("m", ())
let $events-doc := concat("/db/tullio/", $meeting-id, "/events.xml")
let $text-doc := concat("/db/tullio/", $meeting-id, "/text.xml")
let $trans1-doc := concat("/db/tullio/", $meeting-id, "/trans1.xml")
let $start :=   request:get-parameter("start", ()) 
let $stop := request:get-parameter("stop", ()) 
let $numbering := request:get-parameter("numbering", ())
let $firstLang := request:get-parameter("firstLang", ())
let $type := request:get-parameter("type", ())



let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)
let $cellTypes := doc(concat($serverAddress, "/exist/tullio/xml/events.xml"))//event[@cell='y']

(: start & stop:
if there is a start parameter, system will return all p-elements with clip number equal to or greater than start
if there is a stop parameter, system will return all p-elements with clip number *lesser than* stop -- so set 'stop' to the number of the first clip that should not be included
same applies to the combination of start and stop
same rules apply to the returned events
:)

let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()
let $stopAsDec := if ($stop) then xs:decimal(normalize-space($stop)) else ()



let $events := 
	if ($startAsDec and $stopAsDec) 
		then <events>{doc($events-doc)//e[@n >= $startAsDec and @n < $stopAsDec]}</events>
		else 
	if ($startAsDec)
		then <events>{doc($events-doc)//e[@n >= $startAsDec]}</events>
		else
	if ($stopAsDec) 
		then  <events>{doc($events-doc)//e[@n < $stopAsDec]}</events>
		else doc($events-doc)


let $firstCell := doc($events-doc)//e[@c='true'][following-sibling::e[1]/@type[string() = $cellTypes/@id]][1]

let $veryFirstCell := if ($firstCell/preceding-sibling::e) then <group>{$firstCell/preceding-sibling::e}</group> else ()

			
			
			
let $groupedEvents :=			
for $cell in doc($events-doc)//e[@c='true'][following-sibling::e[1]/@type[string() = $cellTypes/@id]]

let $next-cell := $cell/following-sibling::e[@c='true'][following-sibling::e[1]/@type[string() = $cellTypes/@id]][1]

let $remainder := if ($next-cell) then () else $cell/following-sibling::e[@c='true']

return 
<group>{($cell, doc($events-doc)//e[. >> $cell and . << $next-cell], $remainder)}</group>

let $texts := 
	if ($startAsDec and $stopAsDec) 
		then <doc>{doc($text-doc)//p[@c >= $startAsDec and @c < $stopAsDec]}</doc>
		else 
	if ($startAsDec)
		then  <doc>{doc($text-doc)//p[@c >= $startAsDec]}</doc>
		else
	if ($stopAsDec) 
		then   <doc>{doc($text-doc)//p[@c < $stopAsDec]}</doc>
		else doc($text-doc)
			
			
let $trans1 := 
	if ($startAsDec and $stopAsDec) 
		then <trans n="1">{doc($trans1-doc)//p[@c >= $startAsDec and @c < $stopAsDec]}</trans>
		else 
	if ($startAsDec)
		then  <trans n="1">{doc($trans1-doc)//p[@c >= $startAsDec]}</trans>
		else
	if ($stopAsDec) 
		then   <trans n="1">{doc($trans1-doc)//p[@c < $stopAsDec]}</trans>
		else doc($trans1-doc)
	 
let $locks-doc := concat("/db/tullio/", $meeting-id, "/locks.xml")		

let $locked := 	
	if ($startAsDec and $stopAsDec) 
		then <currentLocks>{doc($locks-doc)//lock[@n >= $startAsDec and @n < $stopAsDec]}</currentLocks>
		else 
	if ($startAsDec)
		then <currentLocks>{doc($locks-doc)//lock[@n >= $startAsDec]}</currentLocks>
		else
	if ($stopAsDec) 
		then <currentLocks>{doc($locks-doc)//lock[@n < $stopAsDec]}</currentLocks>
		else <currentLocks>{doc($locks-doc)//lock}</currentLocks>

let $output :=  
<response>
	<status>
	{
		if ($locked/currentLocks/lock or not($meeting-id)) then <failure/>
		else <success/>
	}
	</status>
	<meta>
		<params>{$start, $stop, $numbering, $type}</params>
	</meta>
	<resultSet>
		{<events>{$veryFirstCell, $groupedEvents}</events>, $texts, $trans1}

	</resultSet>
</response>


(: return   $output :)
return transform:transform($output, "../xsl/assemblage-ns.xsl", <parameters><param name="numbering" value="{$numbering}"/><param name="type" value="{$type}"/><param name="firstLang" value="{$firstLang}"/></parameters>)
 













