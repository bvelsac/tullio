xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $stringdata := request:get-parameter("test", ())
let $nodes := util:eval( $stringdata ) 
let $test := <xml>{$nodes}</xml> 

(: create the new collection for this meeting :)

let $collection := concat("/db/tullio/", string($test/data/meeting))


(: let $nice := transform:transform($test, "render.xsl", ())   :)

(: let $debug := xdb:store("/db/test", "abba.xml", <testDoc></testDoc>) :)



return 
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title>XQuery Form Example</title>
 </head>
<body>  
<p>Data saved to collection {$collection}.</p>
</body>
</html>

