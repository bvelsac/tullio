/**
 * Basic sample plugin inserting abbreviation elements into CKEditor editing area.
 */

 
 
 function jq(myid) {


   return '#' + myid.replace(/(:|\.)/g,'\\$1');
 }
 
 
 
 
 
 // define functions for content processing  chain
 
 
function finish(xml2, xsl, object, e) {
	var asString = (new XMLSerializer()).serializeToString(xml2);
	console.debug('enter finish ' + rowId);
	
	console.debug(xml2);
	// replace existing content and event list
	
	// store the new event list in the database
	//$("#newEvents")
	// console.debug('old table');
	// console.debug($(jq(rowId) + " table.events-table"));
	console.debug('added event -- new table');
	// console.debug($("#hidden table.events-table"));
	
	$(jq(rowId) + " table.events-table").replaceWith($("#hidden table.events-table"));
	// $('div.second').replaceWith('<h2>New heading</h2>');
	console.debug("replaced events table");
	
	$(jq(rowId) + " table.events-table").addClass('edited');
	
	$(jq(rowId) + " events").replaceWith($("#hidden events"));
	console.debug("replaced events list");
	
	
	var newContent = $("#hidden div#text").html();
	editor.setData(newContent);
	console.debug("replaced editor content");
	
	console.debug('exit finish');
	
 } 
 
 
 
function finalize(xml, xsl, object, e) {
		console.debug('enter finalize');
		console.debug(xml);
		var asString = (new XMLSerializer()).serializeToString(xml);
		
		console.debug('finalize----' + asString);
	$.transform({
			el: "#hidden",
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "processEditorContent.xsl",
			error: function(html,xsl,xml,object,e) {console.error('transformation failed, ' + e);},
			success:finish
	});
	console.debug('exit finalize');
 }
 
function reconcile(xml, xsl, xmlorig) {
	var asString = (new XMLSerializer()).serializeToString(xml);
	console.debug("reconcile -- xml:");
	console.debug(asString);
	// this step implements the actual event comparison logic
	$.transform({
			async:false, 
			xmlobj:xml, 
			xsl: pathToXSL +  "reconcile.xsl",
			error: function(html,xsl,xml,object,e) {console.error('transformation failed, ' + e);},
			success:finalize
	});
} 
 
 
 
 
 
// Register the plugin with the editor.
// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.plugins.html
CKEDITOR.plugins.add( 'abbr-custom',
{
	// The plugin initialization logic goes inside this method.
	// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.pluginDefinition.html#init
	init: function( editor )
	{
		
							console.debug(".................using macro");
					// console.debug(eventTypes);

					// console.debug(languages);
		
		// Define an editor command that inserts an abbreviation. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#addCommand
		editor.addCommand( 'abbrDialog',new CKEDITOR.dialogCommand( 'abbrDialog' ) );
		// Create a toolbar button that executes the plugin command. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.ui.html#addButton
		editor.ui.addButton( 'Abbr',
		{
			// Toolbar button tooltip.
			label: 'Insert Macro Text',
			// Reference to the plugin command name.
			command: 'abbrDialog',
			// Button's icon file path.
			icon: this.path + 'images/wand.png'
		} );
		// Add a dialog window definition containing all UI elements and listeners.
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#.add
		CKEDITOR.dialog.add( 'abbrDialog', function ( editor )
		{
			return {
				// Basic properties of the dialog window: title, minimum size.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.dialogDefinition.html
				title : 'Event Properties',
				minWidth : 400,
				minHeight : 200,
				// Dialog window contents.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.definition.content.html
				contents :
				[
					{
						// invulwaarden
						
						
						// <e n="1" time="23:45:39" c="y" type="open BHP" length="00:00" committed="X"/>
						
						// Definition of the Basic Settings dialog window tab (page) with its id, label, and contents.
						// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.contentDefinition.html
						id : 'eventInfo',
						label : 'Enter Event',
						elements :
						[						
							{
							type: 'hbox',
							widths: ['25%', '25%', '25%', '25%'],
							children:
								[
									{
										type: 'select',
										label: 'Type',
										id : 'type',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										items :  eventTypes[langChoice],
										'default' : 'AGENDA',
										onChange : function (api) {
											//alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'select',
										label: 'Langue',
										id : 'lang',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										items : languages[langChoice],
										'default' : '',
										onChange : function (api) {
											//alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'select',
										label: 'Orateur',
										id : 'speaker',
										items : speakers.concat(government),
										'default' : '----',
										onChange : function (api) {
											//alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'select',
										label: 'A:',
										id : 'gov',
										multiple : 'true',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										items : government,
										'default' : '',
										onChange : function (api) {
											//alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'text',
										label: 'Heure (hh:mm:ss)',
										id : 'time',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										'default' : '',
										validate : function() {
											var timepattern =  /^([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;
											var time = this.getValue();
											if ( time != '' && !timepattern.test(this.getValue()) ) {
												console.debug('time validation failed');
												alert("L'heure n'est pas correct (hh:mm:ss).");												
											  return false;
											}
											else if ( CKEDITOR.dialog.getCurrent().getValueOf('eventInfo', 'clip') && time=='' ) {
												console.debug('no time indiciation for clip');
												alert("Svp spécifier une indication de temps quand vous crééz un nouveau clip.");												
											  return false;
											}
										}
										/* CKEDITOR.dialog.validate.regex(/^([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/, "Start time is not valid (hh:mm:ss)") */
									},
									{
										type: 'text',
										label: 'Description courte (optionnel)',
										id : 'short',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										'default' : ''
									},
									{
										type: 'checkbox',
										id : 'clip',
										label : 'Nouveau clip ?',
										onClick : function() {
											//alert( 'Checked: ' + this.getValue() );
										}
									}
									/*
									,
									
									{
										type: 'checkbox',
										id : 'agree',
										label : 'Nieuwe clip ?',
										onClick : function() {
											alert( 'Checked: ' + this.getValue() );
										}
									},
									
									*/
								]
						},
						{
							type: 'hbox',
							widths: ['25%', '25%'],
							children:
								[
									{
										type: 'text',
										label: 'Sujet (F)',
										id : 'subjectF',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										'default' : ''
									},
										{
										type: 'text',
										label: 'Sujet N',
										id : 'subjectN',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										'default' : ''
									},
								]
						}
						
						
				]
					} ],
				// This method is invoked once a user closes the dialog window, accepting the changes.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.dialogDefinition.html#onOk
				onOk : function()
				{
					
					
					// A dialog window object.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html 
					var dialog = this;
					// Create a new abbreviation element and an object that will hold the data entered in the dialog window.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.document.html#createElement
					var newEvent = editor.document.createElement( 'event' );
					var clip = dialog.getValueOf('eventInfo', 'clip') ? 'true' : '';
					
					newEvent.setAttribute( 'c', clip );
					newEvent.setAttribute( 'type', dialog.getValueOf( 'eventInfo', 'type' ) );
					newEvent.setAttribute( 'speaker', dialog.getValueOf( 'eventInfo', 'speaker' ) );
					newEvent.setAttribute( 'props', dialog.getValueOf( 'eventInfo', 'gov' ) );
					newEvent.setAttribute( 'time', dialog.getValueOf( 'eventInfo', 'time' ) );
					newEvent.setAttribute( 'notes', dialog.getValueOf( 'eventInfo', 'short' ) );
					newEvent.setAttribute( 'lang', dialog.getValueOf( 'eventInfo', 'lang' ) );

					// Retrieve the value of the "title" field from the "tab1" dialog window tab.
					// Send it to the created element as the "title" attribute.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.element.html#setAttribute
					//abbr.setAttribute( 'title', dialog.getValueOf( 'tab1', 'title' ) );
					// Set the element's text content to the value of the "abbr" dialog window field.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.element.html#setText
					//abbr.setText( dialog.getValueOf( 'tab1', 'abbr' ) );

					// Retrieve the value of the "id" field from the "tab2" dialog window tab.
					// If it is not empty, send it to the created abbreviation element. 
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#getValueOf
					//var id = dialog.getValueOf( 'tab2', 'id' );
					//if ( id )
						//abbr.setAttribute( 'id', id );

					// Insert the newly created abbreviation into the cursor position in the document.					
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#insertElement
					editor.insertElement( newEvent );
					// transform the updated contents of the editor
					
					
					
					// console.debug('titles; ' + titles); .replace(/[&][#]160[;]/gi," ")    .replace(/[&][#]160[;]/gi," ")
					
					var doctype = "<?xml version='1.0'?>\n<!DOCTYPE container [\n<!ENTITY nbsp '&#160;'>\n]>";
					
					var content = doctype + '<container><div id="text">' + editor.getData().replace(/[&][#]160[;]/gi," ") + '</div><div id="events">' + $(jq(rowId) + ' div.structured-events').html() + '</div>'  + '</container>';
					console.debug(content);
					var contentDoc = $.parseXML(content);
					console.debug(contentDoc);
					var asString = (new XMLSerializer()).serializeToString(contentDoc);
					console.debug("sring" + asString);
					contentDoc.getElementsByTagName("container")[0].appendChild(titles);	
					
						// get latest macro variables
					var clipid = edited.slice(1,-2);
									
					var request = $.ajax({
							url: "../xq/return-variables.xql",
							type: "GET",
							data: {
								"start": clipid,  
								"m": mmm,
								'mt' : mt
							},
							async: false,
							contentType: "text/xml"
					});

					request.done(function(result) {
							testeee = (new XMLSerializer()).serializeToString(result); 
							console.debug(testeee);
							contentDoc.getElementsByTagName("container")[0].appendChild(result.documentElement);
					});

					request.fail(function(jqXHR, textStatus) {
							alert( "Request failed: " + textStatus );
					});
					
					
					// start the content processing chain
					// first step is extracting the series of events from the edited content
					/*
								
		$.transform({ dataType:"xml", success:initialize, xml: "../xq/return-combined.xql?m=" + mmm, xsl: "xsl/addclipref.xsl"});

					
					*/
					// 
					
					$.transform({
							xmlobj: contentDoc,
							xsl: pathToXSL +  "flatten.xsl",
							async: false,
							error: function(html,xsl,xml,object,e) {alert(e);},
							success:reconcile
					});
//					newContent = $("#resultpane").html();
//					console.debug("result: " + newContent);
					
//					editor.setData(newContent);
					
					console.debug('exit main ');
					
					
					
					
					
				}
			};
		} );
	}
} );