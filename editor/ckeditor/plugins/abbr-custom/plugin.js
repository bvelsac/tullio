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
										multiple : 'false',
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
										multiple : 'false',
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
										multiple : 'false',
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
					var abbr = editor.document.createElement( 'abbr' );

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
					editor.insertElement( abbr );
				}
			};
		} );
	}
} );