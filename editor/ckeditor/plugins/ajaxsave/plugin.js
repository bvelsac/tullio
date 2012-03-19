 // define functions for content processing  chain
 
var cat;
var clipid;
var stop;
 
function asfinish(xml2, xsl, object, e) {
	var asString = (new XMLSerializer()).serializeToString(xml2);
	console.log('AJAX SAVE');
	console.log(asString);
	console.log(author);
	console.log(cat);
	console.log(clipid);
	console.log(stop);
	console.log(mmm);
	console.log("***");
	//console.log("doc " + asString + "\ncat: " + cat + "\nstart: " + clipid + "\nstop: " + stop  + "\nmeeting: " + mmm  + "\nid: " + author);
		$.ajax({
			url: "/exist/tullio/xq/storeClipEdit.xql",
			type: "POST",
			data: {
				"doc": asString,
				"cat": cat,
				"start": clipid,
				"stop": stop,
				"meeting": mmm,
				"id": author
			},
			async: false
	});
	console.log('after request');
	
	console.log('exit finish');
} 
 
 
 
function asfinalize(xml, xsl, object, e) {
	//	console.log('enter finalize');
	//	console.log(xml);
	//	var asString = (new XMLSerializer()).serializeToString(xml);
	//	console.log('finalize----' + asString);
	$.transform({
			el: "#hidden",
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "group.xsl",
			error: function(html,xsl,xml,object,e) {console.log('transformation failed, ' + e);},
			success:asfinish
	});
	console.log('exit finalize');
 }
 
function asreconcile(xml, xsl, xmlorig) {
	// var asString = (new XMLSerializer()).serializeToString(xml);
	// console.log("reconcile -- xml:");
	// console.log(asString);
	// this step implements the actual event comparison logic
	$.transform({
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "reconcile.xsl",
			error: function(html,xsl,xml,object,e) {console.log('transformation failed, ' + e);},
			success:asfinalize
	});
}



CKEDITOR.plugins.add('ajaxsave',
    {
        init: function(editor)
        {
            
            editor.addCommand( 'ajaxsave',
            {
                exec : function( editor )
                {
									noUpdate = true;
									
									console.log("plugin " + edited);
														clipid = edited.slice(1,-2);
					stop = $(jq("stopevent-" + clipid)).text();
cat = $(jq(edited)).hasClass("orig") ? "orig" : "trans";

	console.log("doc " + asString + "\ncat: " + cat + "\nstart: " + clipid + "\nstop: " + stop  + "\nmeeting: " + mmm  + "\nid: " + author);


// refresh content first .replace(/[&][#]160[;]/gi," ")

					var doctype = "<?xml version='1.0'?>\n<!DOCTYPE container [\n<!ENTITY nbsp '&#160;'>\n]>";
					var content = doctype + '<container><div id="text">' + editor.getData().replace(/[&][#]160[;]/gi," ") + '</div><div id="events">' + $(jq(rowId) + ' div.structured-events').html() + '</div>'  + '</container>';
					var contentDoc = $.parseXML(content);
					contentDoc.getElementsByTagName("container")[0].appendChild(titles);		
					$.transform({
							xmlobj: contentDoc,
							xsl: pathToXSL +  "flatten.xsl",
							async: false,
							error: function(html,xsl,xml,object,e) {alert(e);},
							success:asreconcile
					});



                },
                canUndo : false
            });
            editor.ui.addButton('Ajaxsave',
            {
                label: 'Save Ajax',
                command: 'ajaxsave',
                className : 'cke_button_save'
            });
        }
    });
