xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)

let $meeting := request:get-parameter("m", ())      (:string:)
let $channel := request:get-parameter("channel", ())

let $setuser := xdb:login("/db", "admin", "paris305")
let $agenda := concat("/db/tullio/", $meeting, "/agenda.xml")

let $setChannel := if (doc($agenda)/xml/channel) then update insert <info>{$channel}</info> into doc($agenda)/xml

return ()
 

