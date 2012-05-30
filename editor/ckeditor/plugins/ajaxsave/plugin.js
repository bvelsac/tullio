 // define functions for content processing  chain
 
var cat;
var clipid;
var stop;

 
function asfinish(xml2, xsl, object, e) {
	var asString = (new XMLSerializer()).serializeToString(xml2);
	clipid = edited.slice(1,-2);
	console.log('AJAX SAVE');
	console.log(asString);
	console.log(xml2);
	console.log(author);
	console.log(cat);
	console.log(clipid);
	console.log(stop);
	console.log(mmm);
	console.log("***");
	
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
			success: function() {continueSaveHandler = true;}
	});
		
		if (continueSaveHandler) {
		
		$.ajax({
							url: "/exist/tullio/xq/unlock.xql",
							type: "POST",
							data: {
								"v": cat,
								"n": clipid,
								"id": author,
								"m": mmm
							},
							async: false
					});
	console.log('after requests');
	$(jq(rowId) + " table.events-table").replaceWith($("#hidden table.events-table"));
	// $('div.second').replaceWith('<h2>New heading</h2>');
	$(jq(rowId) + " table.events-table").addClass('edited');
	
	$(jq(rowId) + " events").replaceWith($("#hidden events"));
	
	var newContent = $("#hidden div#text").html();
	editor.setData(newContent);
					
	$("#cke").attr('id', '');

	setTimeout( function() {$(jq(edited)).addClass("content"); edited=''; editor.destroy(); }, 200);					
	noUpdate = false;
		
		}
		
		else {alert('Save action failed, the server could not be reached. Please try again.');}
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
			xsl: pathToXSL +  "processEditorContent.xsl",
			error: function(html,xsl,xml,object,e) {console.log('transformation failed, ' + e);},
			success:asfinish
	});
	console.log('exit finalize');
 }
 
function asreconcile(xml, xsl, xmlorig) {
	var asString = (new XMLSerializer()).serializeToString(xml);
	console.log("reconcile -- xml:");
	console.log(asString);
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
									//console.log("doc " + asString + "\ncat: " + cat + "\nstart: " + clipid + "\nstop: " + stop  + "\nmeeting: " + mmm  + "\nid: " + author);


// refresh content first .replace(/[&][#]160[;]/gi," ")

					var doctype = "<?xml version='1.0' encoding='UTF-8'?>\n<!DOCTYPE container [\n<!ENTITY nbsp '&#160;'>\n]>";
					var content = doctype + '<container><div id="text">' + editor.getData().replace(/[&][#]160[;]/gi," ") + '</div><div id="events">' + $(jq(rowId) + ' div.structured-events').html() + '</div>'  + '</container>';
					var contentDoc = $.parseXML(content);
					contentDoc.getElementsByTagName("container")[0].appendChild(titles);
					
											// get latest macro variables
									
					var request = $.ajax({
							url: "../xq/return-variables.xql",
							type: "GET",
							data: {
								"start": clipid,  
								"m": mmm
							},
							async: false,
							contentType: "text/xml"
					});

					request.done(function(result) {
							testeee = (new XMLSerializer()).serializeToString(result); 
							console.log(testeee);
							contentDoc.getElementsByTagName("container")[0].appendChild(result.documentElement);
					});

					request.fail(function(jqXHR, textStatus) {
							console.log('request fails -----');
							alert( "Save action failed, please try again." );
					});
					
					
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
