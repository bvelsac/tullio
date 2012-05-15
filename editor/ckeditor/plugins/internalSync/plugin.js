/**
 * Basic sample plugin inserting abbreviation elements into CKEditor editing area.
 */

 
 
 function jq(myid) {


   return '#' + myid.replace(/(:|\.)/g,'\\$1');
 }
 
 
 
 
 
 // define functions for content processing  chain
 
 
function finish(xml2, xsl, object, e) {
	//var asString = (new XMLSerializer()).serializeToString(xml2);
	console.log('enter finish ' + rowId);
	
	console.log(xml2);
	// replace existing content and event list
	
	// store the new event list in the database
	//$("#newEvents")
	console.log('old table');
	console.log($(jq(rowId) + " table.events-table"));
	console.log('new table');
	console.log($("#hidden div#text").html());
	
	$(jq(rowId) + " table.events-table").replaceWith($("#hidden table.events-table"));
	// $('div.second').replaceWith('<h2>New heading</h2>');
	$(jq(rowId) + " table.events-table").addClass('edited');
	
	$(jq(rowId) + " events").replaceWith($("#hidden events"));
	
	var newContent = $("#hidden div#text").html();
	editor.setData(newContent);
	
	
	
	
	console.log('exit finish');
	
 } 
 
 
 
function finalize(xml, xsl, object, e) {
	//	console.log('enter finalize');
	//	console.log(xml);
	var asString = (new XMLSerializer()).serializeToString(xml);
	console.log('finalize----' + asString);
	$.transform({
			el: "#hidden",
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "processEditorContent.xsl",
			error: function(html,xsl,xml,object,e) {console.log('transformation failed, ' + e);},
			success:finish
	});
	console.log('exit finalize');
 }
 
function reconcile(xml, xsl, xmlorig) {
	// var asString = (new XMLSerializer()).serializeToString(xml);
	// console.log("reconcile -- xml:");
	// console.log(asString);
	// this step implements the actual event comparison logic
	$.transform({
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "reconcile.xsl",
			error: function(html,xsl,xml,object,e) {console.log('transformation failed, ' + e);},
			success:finalize
	});
} 
 
 
 
 
 
// Register the plugin with the editor.
// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.plugins.html
CKEDITOR.plugins.add( 'internalSync',
{
	// The plugin initialization logic goes inside this method.
	// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.pluginDefinition.html#init
	init: function( editor )
	{
		// Define an editor command that inserts an abbreviation. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#addCommand
		editor.addCommand( 'internalSync', {
				exec: function(editor) {
					var doctype = "<?xml version='1.0'?>\n<!DOCTYPE container [\n<!ENTITY nbsp '&#160;'>\n]>";
					var content = doctype + '<container><div id="text">' + editor.getData().replace(/[&][#]160[;]/gi," ") + '</div><div id="events">' + $(jq(rowId) + ' div.structured-events').html() + '</div>'  + '</container>';
					var contentDoc = $.parseXML(content);
					contentDoc.getElementsByTagName("container")[0].appendChild(titles);
					
					// get latest macro variables
					var clipid = edited.slice(1,-2);
									
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
							alert( "Request failed: " + textStatus );
					});
					
						testeee = (new XMLSerializer()).serializeToString(contentDoc); 
							console.log("init //////" + testeee);
					
					
					$.transform({
							xmlobj: contentDoc,
							xsl: pathToXSL +  "flatten.xsl",
							async: false,
							error: function(html,xsl,xml,object,e) {alert(e);},
							success:reconcile
					});
				}
				});
		editor.ui.addButton('internalSync',
            {
                label: 'Sync Events with Text',
                command: 'internalSync',
								icon: this.path + 'sync.png'
            });
	}
	});
