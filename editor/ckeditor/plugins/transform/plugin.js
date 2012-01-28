var global = "test";
var pathToXSL = "/exist/tullio/editor/xsl/";



function helper(xml,xsl,xmlorig) {
	console.log('helper: ' + xml);
	console.log('helper: ' + global);
	// editor.setData(xml);
	//	editor.insertHtml("<p>insert after transform</p>");
	global = xml;
	console.log('helper-end: ' + global);
}


function asXMLSuccess(xml,xsl,xmlorig) {
	$("#result").transform({xmlobj:xml,xsl:"xsl/cds.xsl", xslParams:{test:"This was transformed by setting dataType to xml in the initial request which returned an XML Document as the first argument. Then it set xmlobj in the subsequent request with that XML Document."},
		error : function(html,xsl,xml,obj,ex){
			alert("Error - " + ex.message);
		}
	});
}







function passComplete(xml,xsl,xmlorig,obj) {
	
	alert(xml);
	alert(xmlorig);
	console.log(xml);
	
	var str = "File transform complete.\r\nPassed values:\r\n";
	for(var x in obj.pass) {
		str += x + ": " + obj.pass[x] + "\r\n";
	}
	alert(str);
	
	var cke = obj.pass['instance'];
	
	cke.insertHtml("<p>in success handler</p>");
	alert("insert xml ");
	cke.setData(xml);
		alert("insert xmlorig ");
	cke.setData(xmlorig);
	// console.log(html);
	// obj.pass['instance'].setData(html);
	
	
}


CKEDITOR.plugins.add('transform',
	{
		init: function(editor)
		{
			editor.addCommand( 'transform',
			{
				// Define a function that will be fired when the command is executed.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.commandDefinition.html#exec
				exec : function( editor )
				{    
					
					var titles;
				  editor.insertHtml("<p>insert before transform</p>");
					var content = '<container><div id="text">' + editor.getData() + '</div><div id="events">' + eventsList + '</div>' + titles + '</container>';
					
					// hier eenvoudig ook de content van de structured events en de titles toeveogen, ook als string en via html extractie in jquery
					
					console.log(content);
					console.log(editor.id);
					
//					$(editor).find("iframe").find("body").html("<p>cou cou</p>");
					
					
					
					// first transformation: reconcile old and new events
					
					
					
					// second transformation: generate new events list in html and xml and new text blocks in html
					
					
					// replace the original content
					
					
					$.transform({
							el : "#resultpane",
							xmlstr: content,
							xsl: pathToXSL +  "reconcile.xsl",
							async: false
					});
					
					
					
					// $("#resultpane").transform({xmlstr:content, xsl: pathToXSL +  "getEvents.xsl", success:helper});
					newContent = $("#resultpane").html();
					console.log("result: " + newContent);
					
					editor.setData(newContent);
					
					console.log('exit main ');
					// var timestamp = new Date();
					// Insert the timestamp into the document.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#insertHtml
					// editor.insertHtml( 'The current date and time is: <em>' + timestamp.toString() + '</em>' );
				}
			});
		// Create a toolbar button that executes the plugin command. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.ui.html#addButton
		editor.ui.addButton( 'Transform',
		{
			// Toolbar button tooltip.
			label: 'Process content',
			// Reference to the plugin command name.
			command: 'transform',
			// Button's icon file path.
			icon: this.path + 'images/up_16.png'
		} );
		}
		
	});
