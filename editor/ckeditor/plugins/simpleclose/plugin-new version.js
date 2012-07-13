 // define functions for content processing  chain
 
var cat;
var clipid;
var stop;



CKEDITOR.plugins.add('simpleclose',
    {
        init: function(editor)
        {
            
            editor.addCommand( 'simpleclose',
            {
                exec : function( editor )
                {
									
									var doIt = confirm("Leave clip ?");
									
									if (doIt) {
										noUpdate = true;
										console.log("plugin " + edited);
										clipid = edited.slice(1,-2);
										stop = $(jq("stopevent-" + clipid)).text();
										cat = $(jq(edited)).hasClass("orig") ? "orig" : "trans";
									//console.log("doc " + asString + "\ncat: " + cat + "\nstart: " + clipid + "\nstop: " + stop  + "\nmeeting: " + mmm  + "\nid: " + author);
									
									
									
									
									
										$.ajax({
											url: "/exist/tullio/xq/unlock.xql",
											type: "POST",
											data: {
												"v": cat,
												"n": clipid,
												"id": author,
												"m": mmm
											},
											async: false,
											success : function () {
												editor.destroy(false);
												setTimeout("$('#cke').attr('id', '');", 100);
												
												$(jq(edited)).addClass('content');
												edited='';
												editor = '';
											}
										});
									}
									
									noUpdate = false;
									console.log('exit finish');
						
                },
                canUndo : false
            });
            editor.ui.addButton('Simpleclose',
            {
                label: 'Close the clip',
                command: 'simpleclose',
									icon: this.path + 'close_icon.gif'
            });
        }
    });
