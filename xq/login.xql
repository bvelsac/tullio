xquery version "1.0";
(: $Id: login.xql 10401 2009-11-08 19:01:26Z wolfgang_m $ :)

declare namespace request="http://exist-db.org/xquery/request";
declare namespace response="http://exist-db.org/xquery/response";
declare namespace session="http://exist-db.org/xquery/session";
declare namespace xdb="http://exist-db.org/xquery/xmldb";

declare variable $database-uri as xs:string { "xmldb:exist:///db" };
declare variable $redirect-uri as xs:anyURI { xs:anyURI("/exist/tullio/home.html") };

declare function local:login($user as xs:string) as element()?
{
    let $pass := request:get-parameter("pass", ""),
        $login := xdb:authenticate($database-uri, $user, $pass)
    return
        if ($login) then (
            session:set-attribute("user", $user),
            session:set-attribute("password", $pass),
            response:redirect-to(session:encode-url($redirect-uri))
        ) else
            <p>Login failed! Please retry.</p>
};

declare function local:do-login() as element()?
{
    let $user := request:get-parameter("user", ())
    return
        if ($user) then
            local:login($user)
        else ()
};

session:invalidate(),
session:create(),

<html>
<head>
<title>Tullio :: Log In</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />

<!--
<link rel="stylesheet" type="text/css" href="/exist/tullio/login/login.css"  />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.js" />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.js" />
<script type="text/javascript" src="/exist/tullio/login/local.js" />
-->
</head>
<body>
<div id="beaker"></div>
<div>
<p>Welcome to Tullio! Please log in.</p>

        <form action="{session:encode-url(request:get-uri())}">
            <table class="login" cellpadding="5">
                
                <tr>
                    <td align="left">Username:</td>
                    <td><input name="user" type="text" size="20"/></td>
                </tr>
                <tr>
                    <td align="left">Password:</td>
                    <td><input name="pass" type="password" size="20"/></td>
                </tr>
                <tr>
                    <td colspan="2" align="left"><input id="mainLogin" type="submit"/></td>
                </tr>
            </table>
        </form>
        { local:do-login() }
</div>
</body>
</html>


