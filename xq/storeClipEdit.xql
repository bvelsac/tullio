xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $meeting := request:get-parameter("meeting", ())      (:string:)
let $text := request:get-parameter("doc", ())            (:elements:)
let $category := request:get-parameter("cat", ())         (:string -- original or translation :)
let $start := request:get-parameter("start", ())          (: number -- id of start event -- included :)
let $stop := request:get-parameter("stop", ())            (: number -- id of stop event -- included :)

let $nodes :=  if ($text) then util:eval( $text ) else () 
		let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()
		let $stopAsDec := xs:decimal($nodes//events/@next)
		let $doc := if ($category = 'orig') then "/text.xml" else if ($category = 'trans') then "/trans1.xml" else ()
		let $text-doc := concat("/db/tullio/", $meeting, $doc)
		let $op := concat('op', util:random())
		let $clumsy := <e marker='invalid' op='{$op}'/>
		let $atts := $clumsy/@* 
		let $touch := doc($text-doc)//p[@c = $startAsDec]
		let $setuser := xdb:login("/db", "admin", "paris305")
		let $nice := transform:transform($nodes, "../xsl/cleanEdit.xsl", ())
		
		let $update := if ($nice) then (update insert $atts into $touch, update insert $nice//p preceding $touch[1], update delete doc($text-doc)//p[@op=$op][@marker='invalid']) else ("something went wrong")
		let $correct := if ( not($touch) ) then 
											if ( doc($text-doc)//p[@c > $startAsDec] ) then update insert $nice//p preceding doc($text-doc)//p[@c > $startAsDec][1] 
											else update insert $nice//p into doc($text-doc)/*
										else ()
										
										
		let $updateEvents := if ($category = 'orig') then 
			let $events-doc := concat("/db/tullio/", $meeting, '/events.xml'),
			$touch2 := doc($events-doc)//e[@n < $stopAsDec and @n >=$startAsDec],
			$list := for $x in $touch2 return $x/@n cast as xs:string,
			$update2 := if ($nodes//events) then (update insert $atts into $touch2, update insert $nodes//events/e[not(@active='no')] preceding $touch2[1], update delete doc($events-doc)//e[@op=$op][@marker='invalid']) else ()
			return <result>{$touch}</result>
			else()
			return <result>{$touch}</result>
