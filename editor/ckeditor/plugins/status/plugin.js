/**
 * Basic sample plugin inserting abbreviation elements into CKEditor editing area.
 */

// Register the plugin with the editor.
// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.plugins.html
CKEDITOR.plugins.add( 'status',
{
	// The plugin initialization logic goes inside this method.
	// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.pluginDefinition.html#init
	init: function( editor )
	{
		// Define an editor command that inserts an abbreviation. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#addCommand
		editor.addCommand( 'statusDialog',new CKEDITOR.dialogCommand( 'statusDialog' ) );
		// Create a toolbar button that executes the plugin command. 
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.ui.html#addButton
		editor.ui.addButton( 'Status',
		{
			// Toolbar button tooltip.
			label: 'Update Status',
			// Reference to the plugin command name.
			command: 'statusDialog',
			// Button's icon file path.
			icon: this.path + 'status.png'
		} );
		// Add a dialog window definition containing all UI elements and listeners.
		// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#.add
		CKEDITOR.dialog.add( 'statusDialog', function ( editor )
		{
			return {
				// Basic properties of the dialog window: title, minimum size.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.dialogDefinition.html
				title : 'Change the Clip Status',
				minWidth : 400,
				minHeight : 200,
				// Dialog window contents.
				// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.definition.content.html
				contents :
				[
				{
					id : 'someId',
					label : 'Change Status',
					elements :
					[
					{
										type: 'select',
										id : 'status',
										items : [['Redactie bezig', 'EC'], ['redactie klaar', 'R']],
										'default' : 'EC',
										onChange : function (api) {
											alert('Current value: ' + this.getValue() );
										}
					}
					]
				}
				],
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
					// abbr.setAttribute( 'title', dialog.getValueOf( 'tab1', 'title' ) );
					// Set the element's text content to the value of the "abbr" dialog window field.
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dom.element.html#setText
					abbr.setText( dialog.getValueOf( 'someId', 'status' ) );

					// Retrieve the value of the "id" field from the "tab2" dialog window tab.
					// If it is not empty, send it to the created abbreviation element. 
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.dialog.html#getValueOf
					// var id = dialog.getValueOf( 'tab2', 'id' );
					// if ( id )
						// abbr.setAttribute( 'id', id );

					// Insert the newly created abbreviation into the cursor position in the document.					
					// http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.editor.html#insertElement
					editor.insertElement( abbr );
				}
			};
		} );
	}
} );