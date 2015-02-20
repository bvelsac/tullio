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
			selection.removeAttribute( 'class' );
			ascendant = selection.getAscendant( 'p', true ); 
			
			ascendant.removeClass( 'fragmentNL' );
			ascendant.removeClass('fragmentFR');
			ascendant.removeClass('fragment');			
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