xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";

let $serverAddress:= concat("http://", doc('/db/tullioconfig/config.xml')/config/serverAddress)

let $meeting := request:get-parameter("m", ())      (:string:)

let $fromClient := request:get-parameter("value", ())


let $setuser := xdb:login("/db", "admin", "paris305")
let $agenda := concat("/db/tullio/", $meeting, "/agenda.xml")

let $setChannel := 
	if (doc($agenda)//data/info/channel) 
		then update replace doc($agenda)//data/info/channel with <channel>{$fromClient}</channel> 
	else if (doc($agenda)//data/info) 
		then update insert <channel>{$fromClient}</channel> into doc($agenda)//data/info 
	else ()

return $fromClient
