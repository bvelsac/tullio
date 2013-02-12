// define variables and functions for content processing  chain
var cat;
var clipid;
var stop;


function jq(myid) {
			return '#' + myid.replace(/(:|\.)/g,'\\$1');
		}

function testDoc(xmlDoc) {
  testeee = (new XMLSerializer()).serializeToString(xmlDoc);
  if (testeee.indexOf("<parsererror") != -1) {
    console.log('>>> parse error in xml doc');
    // console.log(testeee);
  } else {
    console.log('doc ok');
  }
}

function testString(xmlStr) {
  testeee = $.parseXML(xmlStr);
}

function asfinish(xml2, xsl, object, e) {
  var asString = (new XMLSerializer()).serializeToString(xml2);
  clipid = edited.slice(1, -2);
  var continueSaveHandler = false;
  //console.log("doc " + asString + "\ncat: " + cat + "\nstart: " + clipid + "\nstop: " + stop  + "\nmeeting: " + mmm  + "\nid: " + author);
  $.ajax({
    url: "/exist/tullio/xq/storeClipEdit.xql",
    type: "POST",
    contentType: "application/x-www-form-urlencoded;charset=UTF-8",
    data: {
      "doc": asString,
      "cat": cat,
      "start": clipid,
      "stop": stop,
      "meeting": mmm,
      "id": author
    },
    async: false,
    success: function (response) {
      continueSaveHandler = true;
      console.log(response);
      console.log(jq(edited));
      
      $(jq(edited)).animate({
        'opacity': 0.25
      }, 600);
      $(jq(edited)).animate({
        'opacity': 1.00
      }, 600);
    },
    error: function (jqXHR, textStatus, errorThrown) {
      alert("Save action failed." + textStatus);
    }
  });
  noUpdate = false;
  console.log('exit finish');
}

function asfinalize(xml, xsl, object, e) {
  //	console.log('enter finalize');
  //	console.log(xml);
  //	var asString = (new XMLSerializer()).serializeToString(xml);
  //	console.log('finalize----' + asString);
  $.transform({
    el: "#hidden",
    async: false,
    xmlobj: xml,
    xsl: pathToXSL + "processEditorContent.xsl",
    error: function (html, xsl, xml, object, e) {
      console.log('transformation failed, ' + e);
    },
    success: asfinish
  });
  console.log('exit finalize');
}

function asreconcile(xml, xsl, xmlorig) {
  testDoc(xml);
  var asString = (new XMLSerializer()).serializeToString(xml);
  // console.log("reconcile -- xml:");
  // console.log(asString);
  // this step implements the actual event comparison logic
  $.transform({
    async: false,
    xmlobj: xml,
    xsl: pathToXSL + "reconcile.xsl",
    error: function (html, xsl, xml, object, e) {
      console.log('transformation failed, ' + e);
    },
    success: asfinalize
  });
}
CKEDITOR.plugins.add('exit', {
  init: function (editor) {
    editor.addCommand('exit', {
      exec: function (editor) {
      	      
        clipid = edited.slice(1, -2);
        stop = $(jq("stopevent-" + clipid)).text();
        cat = $(jq(edited)).hasClass("orig") ? "orig" : "trans";
        var snap2 = editor.getSnapshot();
        // console.log(snap.replace(/\s+/gi, ''));
        // console.log(snap2.replace(/<br\/?>/gi, '').replace(/\s+/gi, ''));
        var noChange = false ;
        var doIt = false;
        if ( snap2.replace(/<br\/?>/gi, '').replace(/\s+/gi, '') == snap.replace(/\s+/gi, '') ) {
        	noChange = true;
        	
        	
        }
        if ( !noChange ) {
        	doIt = confirm("Save text before exit ?");
        	
        }
        
      
        if (doIt) {
          // first save the editor's content
          editor.fire('saveSnapshot');
          var currentData = editor.getData();
          // additionally throw away cke-specific attributes as they will crash the parser
          var clean = Encoder.HTML2Numerical(editor.getSnapshot().replace(/[-\w]*data-cke[^\s]*/gi, ""));
          // escape curly braces because they have special meaning in XQuery
          clean = clean.replace(/\{/gi, '{{');
          clean = clean.replace(/\}/gi, '}}');
          try {
            clean = HTMLtoXML(clean);
          } catch (err) {
            alert("Invalid Document");
            return true;
          }
          noUpdate = true;
          var doctype = "<?xml version='1.0' encoding='UTF-8'?>\n<!DOCTYPE container [\n<!ENTITY nbsp '&#160;'>\n]>";
          var content = doctype + '<container><div id="text">' + clean.replace(/[&][#]160[;]/gi, " ") + '</div><div id="events">' + $(jq(rowId) + ' div.structured-events').html() + '</div>' + '</container>';
          var contentDoc = $.parseXML(content);
          testDoc(contentDoc);
          contentDoc.getElementsByTagName("container")[0].appendChild(titles);
          // get latest macro variables
          var request = $.ajax({
            url: "../xq/return-variables.xql",
            type: "GET",
            data: {
              "start": clipid,
              "m": mmm,
              'mt': mt
            },
            async: false,
            contentType: "text/xml"
          });
          request.done(function (result) {
            testeee = (new XMLSerializer()).serializeToString(result);
            contentDoc.getElementsByTagName("container")[0].appendChild(result.documentElement);
          });
          request.fail(function (jqXHR, textStatus) {
            console.log('request fails -----');
            alert("Save action failed, please try again.");
          });
          testDoc(contentDoc);
          $.transform({
            xmlobj: contentDoc,
            xsl: pathToXSL + "flatten.xsl",
            async: false,
            error: function (html, xsl, xml, object, e) {
              alert(e);
            },
            success: asreconcile
          });
        }
        // now try to unlock and then unload the editor	 
        noUpdate = true;
        $.ajax({
          url: "/exist/tullio/xq/unlock.xql",
          type: "POST",
          data: {
            "v": cat,
            "n": clipid,
            "id": author,
            "m": mmm
          },
          async: false,
          success: function () {
          	  
          	  
          	  
            setTimeout("editor.destroy(false); editor = null; $('#cke').attr('id', ''); $(jq(edited)).addClass('content'); edited='';           if (runTrans == 'yes') {$(jq('R' + clipid)).attr('style', 'height: auto;'); $(jq('R' + clipid)).children('td').children('div.editable').attr('style', 'height: auto;');} ; noUpdate = false;", 100);
          }
        });
        
      },
      canUndo: false
    });
    editor.ui.addButton('Exit', {
      label: 'Close the clip',
      command: 'exit',
      icon: this.path + 'close_dark16x16.gif'
    });
  }
});
