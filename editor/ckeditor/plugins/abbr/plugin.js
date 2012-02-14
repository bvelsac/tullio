/**
 * Basic sample plugin inserting abbreviation elements into CKEditor editing area.
 */

// Register the plugin with the editor.
// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.plugins.html
CKEDITOR.plugins.add( 'abbr',
{
	// The plugin initialization logic goes inside this method.
	// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.pluginDefinition.html#init
	init: function( editor )
	{
		// Define an editor command that inserts an abbreviation. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#addCommand
		editor.addCommand( 'abbrDialog',new CKEDITOR.dialogCommand( 'abbrDialog' ) );
		// Create a toolbar button that executes the plugin command. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.ui.html#addButton
		editor.ui.addButton( 'Abbr',
		{
			// Toolbar button tooltip.
			label: 'Insert Abbreviation',
			// Reference to the plugin command name.
			command: 'abbrDialog',
			// Button's icon file path.
			icon: this.path + 'images/icon.png'
		} );
		// Add a dialog window definition containing all UI elements and listeners.
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#.add
		CKEDITOR.dialog.add( 'abbrDialog', function ( editor )
		{
			return {
				// Basic properties of the dialog window: title, minimum size.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.dialogDefinition.html
				title : 'Abbreviation Properties',
				minWidth : 400,
				minHeight : 200,
				// Dialog window contents.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.definition.content.html
				contents :
				[
										{
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
										items : eventTypes[langChoice],
										'default' : 'QO-MV',
										onChange : function (api) {
											alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'select',
										label: 'Type',
										id : 'type2',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										items : eventTypes[langChoice],
										'default' : 'QO-MV',
										onChange : function (api) {
											alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'select',
										id : 'speaker',
										// items : [['Agenda', 'A'], ['Sprekers', 'S'], ['Zaal', 'Z']],
										items : speakers,
										'default' : '',
										onChange : function (api) {
											alert('Current value: ' + this.getValue() );
										}
									},
									{
										type: 'checkbox',
										id : 'agree',
										label : 'Nieuwe clip ?',
										onClick : function() {
											alert( 'Checked: ' + this.getValue() );
										}
									}
								]
						}
				]
			}
				],
				// This method is invoked once a user closes the dialog window, accepting the changes.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.dialogDefinition.html#onOk
				onOk : function()
				
				{    
					
					var titles;
					
				  editor.insertHtml("<p>insert before transform</p>");
					var content = '<container><div id="text">' + editor.getData() + '</div><div id="events">' + $('#' + rowId + ' div.structured-events').html() + '</div>' + titlesAsString + '</container>';
					
					// hier eenvoudig ook de content van de structured events en de titles toeveogen, ook als string en via html extractie in jquery
					
					console.log(titlesDoc);
					
//					$(editor).find("iframe").find("body").html("<p>cou cou</p>");
					
					
					
					// first transformation: reconcile old and new events
					
					
					
					// second transformation: generate new events list in html and xml and new text blocks in html
					
					
					// replace the original content
					
					
					$.transform({
							el : "#resultpane",
							xmlobj: titlesDoc,
							xsl: pathToXSL +  "reconcile.xsl",
							async: false,
							error: function(html,xsl,xml,object,e) {alert(e);}
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
				/*
				{
					// A dialog window object.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html 
					var dialog = this;
					// Create a new abbreviation element and an object that will hold the data entered in the dialog window.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.document.html#createElement
					var abbr = editor.document.createElement( 'abbr' );

					// Retrieve the value of the "title" field from the "tab1" dialog window tab.
					// Send it to the created element as the "title" attribute.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.element.html#setAttribute
					abbr.setAttribute( 'title', dialog.getValueOf( 'tab1', 'title' ) );
					// Set the element's text content to the value of the "abbr" dialog window field.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.element.html#setText
					abbr.setText( dialog.getValueOf( 'tab1', 'abbr' ) );

					// Retrieve the value of the "id" field from the "tab2" dialog window tab.
					// If it is not empty, send it to the created abbreviation element. 
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#getValueOf
					var id = dialog.getValueOf( 'tab2', 'id' );
					if ( id )
						abbr.setAttribute( 'id', id );

					// Insert the newly created abbreviation into the cursor position in the document.					
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#insertElement
					editor.insertElement( abbr );
				}
				*/
			};
		} );
	}
} );