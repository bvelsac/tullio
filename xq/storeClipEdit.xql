xquery version "1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace request="http://exist-db.org/xquery/request";

declare option output:method "xml";
declare option output:media-type "application/xml";

import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

 

let $meeting := request:get-parameter("meeting", ())      (:string:)
let $text := request:get-parameter("doc", ())            (:elements:)
let $category := request:get-parameter("cat", ())         (:string -- original or translation :)
let $start := request:get-parameter("start", ())          (: number -- id of start event -- included :)
let $stop := request:get-parameter("stop", ())            (: number -- id of stop event -- included :)

let $setuser := xdb:login("/db", "admin", "paris305")

let $docsize := if ($text) then string-length($text) else ()
let $nodes :=  if ($text) then util:eval( $text ) else () 
		let $startAsDec := if ($start) then xs:decimal(normalize-space($start)) else ()
		let $stopAsDec := xs:decimal($nodes//events/@next)
		let $doc := if ($category = 'orig') then "/text.xml" else if ($category = 'trans') then "/trans1.xml" else ()
		let $text-doc := doc(concat("/db/tullio/", $meeting, $doc))
		
		let $toBeReplaced := $text-doc//p[@c = $startAsDec] 
		let $replacement := transform:transform($nodes, "../xsl/cleanEdit.xsl", ())
		
		let $log-doc := concat("/db/tullio/", $meeting, "/eventsLog.xml")
		
		let $update := if ($replacement) then 
			(	update insert $replacement//p preceding $toBeReplaced[1], update delete $toBeReplaced,
				"update completed"
			) 
			else ("update went wrong")
		
		let $correct := if ( not($toBeReplaced) ) then 
											if ( $text-doc//p[@c > $startAsDec] ) then 
												(update insert $replacement//p preceding $text-doc//p[@c > $startAsDec][1],
											"insert completed")
											else (update insert $replacement//p into $text-doc/doc, "insert completed")
										else ("no insert")
										
										
		let $updateEvents := 
	    if ($category = 'orig') 
	    then 
				let $events-doc := doc(concat("/db/tullio/", $meeting, '/events.xml')),
						$touch2 := $events-doc//e[@n < $stopAsDec and @n >=$startAsDec],
						$list := for $x in $touch2 return $x/@n cast as xs:string,
						$update2 := 
							if ($nodes//events) 
						  then 
							  (	 
								  update insert $nodes//events/e[not(@active='no')] preceding $touch2[1], 
								  update delete $touch2 
								) 
							else (),
						$logEntry := 
									<store doc="{$log-doc}" start="{$start}" startAsDec="{$startAsDec}" stop="{$stop}" stopAsDec="{$stopAsDec}">
										<replaced>{$list}</replaced>
										<submission>{$nodes//events}</submission>
										<newEvents>{$nodes//events/e[not(@active='no')]}</newEvents>
									</store>,
						$updateLog := 
							if (doc($log-doc)/log) 
						  then 
							  update insert $logEntry into doc($log-doc)/log
							else 
								xdb:store(concat("/db/tullio/", $meeting), "eventsLog.xml", <log>{$logEntry}</log>)
			return <test></test>
		else ()
					return <saveResult> <update>{$update}</update><insert>{$correct}</insert><inputLength>{$docsize}</inputLength>
				</saveResult>
