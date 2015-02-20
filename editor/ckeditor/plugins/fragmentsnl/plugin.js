CKEDITOR.plugins.add( 'fragmentsnl',
{
	init: function( editor )
	{
		//Plugin logic goes here.
		
		editor.addCommand( 'fragmentsnl',
	{
		exec : function( editor )
		{    
			
			
			var selection = editor.getSelection().getStartElement();
			ascendant = selection.getAscendant( 'p', true ); 
			
			ascendant.removeClass( 'fragmentFR' );
			ascendant.addClass('fragmentNL');
			ascendant.addClass('fragment');
			
		}
	});
		
		editor.ui.addButton( 'Fragmentsnl',
{
	label: 'Fragment NL',
	command: 'fragmentsnl',
	icon: this.path + 'nl_on.gif'
} );
		
		
		
	}
} );