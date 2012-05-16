CKEDITOR.plugins.add( 'remove',
{
	init: function( editor )
	{
		//Plugin logic goes here.
		
		editor.addCommand( 'remove',
	{
		exec : function( editor )
		{    
			
			
			var selection = editor.getSelection().getStartElement();
			selection.removeAttribute( 'title' );
			
		}
	});
		
		editor.ui.addButton( 'Remove',
{
	label: 'Make Simple Text',
	command: 'remove',
	icon: this.path + 'plain_text_icon.png'
} );
		
		
		
	}
} );