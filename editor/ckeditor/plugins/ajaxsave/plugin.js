CKEDITOR.plugins.add('ajaxsave',
    {
        init: function(editor)
        {
            var pluginName = 'ajaxsave';
            editor.addCommand( pluginName,
            {
                exec : function( editor )
                {
									
									console.log("plugin " + edited);
														var clipid = edited.slice(1,-2);
					var stop = $(jq("stopevent-" + clipid)).text();
var cat = $(jq(edited)).hasClass("orig") ? "orig" : "trans";
var editedcontent = "<wrapper n='" + clipid + "'>" + editor.getData().replace(/[&][#]160[;]/gi," ") + "</wrapper>";
									
									
													$.post("../xq/storeClipEdit.xql", {
							"text": editedcontent,
							"cat": cat,
							"start": clipid,
							"stop": stop,
							"meeting": mmm
					}, function(data) {
							// alert("Data Loaded: " + data);
					});
					$.post("../xq/unlock.xql", {
							"v": cat,
							"n": clipid,
							"id": author,
							"m": mmm
					}, function(data) {
							// alert("Data Loaded: " + data);
					});
					
				setTimeout( function() { edited=''; editor.destroy() }, 50);					
									
                },
                canUndo : true
            });
            editor.ui.addButton('Ajaxsave',
            {
                label: 'Save Ajax',
                command: pluginName,
                className : 'cke_button_save'
            });
        }
    });
