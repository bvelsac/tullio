xquery version "1.0";
(: $Id: hello.xq 6434 2007-08-28 18:59:23Z ellefj $ :)
(: How to do plain dynamic Web pages with XQuery and eXist extensions :)

declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $m := request:get-parameter("m", ())
let $agenda := doc(concat('/db/tullio/', $m ,'/agenda.xml'))


let $table := transform:transform($agenda, "listing.xsl", ())

return 



$table

