CKEDITOR.plugins.add( 'fragmentsfr',
{
	init: function( editor )
	{
		//Plugin logic goes here.
		
		editor.addCommand( 'fragmentsfr',
	{
		exec : function( editor )
		{    
			
			
			var selection = editor.getSelection().getStartElement();
			ascendant = selection.getAscendant( 'p', true ); 
			
			ascendant.removeClass( 'fragmentNL' );
			ascendant.addClass('fragmentFR');
			ascendant.addClass('fragment');
			
		}
	});
		
		editor.ui.addButton( 'Fragmentsfr',
{
	label: 'Fragment FR',
	command: 'fragmentsfr',
	icon: this.path + 'fr_on.gif'
} );
		
		
		
	}
} );