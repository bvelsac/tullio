/*
  
Tullio

JS for Logger 

Grid based on Ext JS 4

http://www.sencha.com/

GNU General Public License Usage
This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.

*/
// 900 voor logger 400 voor agenda

function toHumanTime(x) {
	milliSecs = x;
	msSecs = (1000);
	msMins = (msSecs * 60);
	msHours = (msMins * 60);
	numHours = Math.floor(milliSecs/msHours);
	numMins = Math.floor((milliSecs - (numHours * msHours)) / msMins);
	numSecs = Math.floor((milliSecs - (numHours * msHours) - (numMins * msMins))/ msSecs);

	if (numSecs < 10){
		numSecs = "0" + numSecs;
	};
	if (numMins < 10){
		numMins = "0" + numMins;
	};
	/*if (numHours < 10) {
		numHours = "0" + numHours;
	}
	*/
	resultString = numMins + ":" + numSecs;
	return resultString;
}


Ext.Loader.setConfig({
    enabled: true
});
Ext.Loader.setPath('Ext.ux', '/exist/tullio/js-lib/ext/examples/ux');
Ext.require([
    'Ext.selection.CellModel',
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.util.*',
    'Ext.state.*',
    'Ext.form.*',
    'Ext.ux.CheckColumn'
]);



// http://localhost:8080/exist/rest//db/tullio/2012-03-29-AM_COMM-ECO/events.xml

Ext.onReady(function(){
		
		
		var m = $.QueryString["m"];
		var lang = $.QueryString["lang"];
		console.log(m + lang);
		console.log(eventTypes[lang]);
		var counter;
		
		
		$('#agendaplaceholder').load('/exist/tullio/newlogger/hello3.xql?m=' + m, function() {});
		
		
		// reverse labels and values for eventTypes
		var eventTypesDict = [];
		var eventTypesLookup = {};
		for (var i = 0; i < eventTypes[lang].length; i++) {
			eventTypesDict[i] = [ eventTypes[lang][i][1], eventTypes[lang][i][0] ];
			eventTypesLookup[eventTypes[lang][i][1]] = eventTypes[lang][i][0];
		}
		console.log(eventTypesDict);
		
		// reverse labels and values for all speakers
		var allSpeakersDict = [];
		
		for (var i = 0; i < allSpeakers.length; i++) {
			allSpeakersDict[i] = [ allSpeakers[i][1], allSpeakers[i][0] ];
		}

		document.title += ' ' + m;
		// first query the server for the clipstart number (to make sure the user doesn't overwrite existing data)
		// logger grid shows only uncommitted log entries
		// or should prevent inserting, deleting committed entries
		// numbers of committed entries cannot be updated
		
		
		function makeTime(v, record){
			console.log(record);
			
		}
		/*
		Ext.util.Format.comboRenderer = function(combo){
    return function(value){
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : 'no';
    }
}
		*/
		
		function updateClipLength(store) {
			if (store.getCount() < 2) return;
			
			var size = store.getCount();
			var moreRecent = "";
			var record;
			var langMem;
			// set language for all events
			console.log(store.getAt(size-1).data.lang);
			if (store.getAt(size-1).data.lang == "" || store.getAt(size-1).data.lang == undefined) {
				alert("Set language for first record"); return "stop";
			}
			
			for (i=size-1; i >= 0; i--) {
				record = store.getAt(i);
				
				if (record.data.lang == "" || record.data.lang == undefined) {
					record.set('lang', langMem);
				}
				else {langMem = record.data.lang;}
			}
			
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				console.log(record.data.time + 'L::' + record.data.length);
				
				if (record.data.c) {
					console.log('clip');
					var current = new XDate("2011-09-05T" + record.data.time);
					if (moreRecent != '') {
						var diff = moreRecent - current;
						record.set('length', toHumanTime(diff));
						console.log('length set' + toHumanTime(diff));
					}
					moreRecent = current;
				}
				else {
					record.set('length', ' ');
				}
			}
		}
		
		function setCommitStatus(options, eOpts) {
			
			var size = store.getCount();
			var found;
			var record;
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				if (record.data.commit == 'P') break;
				if (found == "P") record.set('commit', 'P');
				if (record.data.c && found !='P') {found = "P"; record.set('commit', 'F');} 
			}
			console.log('commit');
			console.log(options);
			console.log(eOpts);
			console.log(store);
		}
		/*
			var size = store.getCount();
			var found;
			var record;
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				console.log(record.data.committed);
				if (record.data.committed == 'P') break;
				if (found == "P") record.set('committed', 'P');
				if (record.data.clip) found = "P"; 
			}
		*/
		// items have no nr as this is created server side, markers added etc.
		
    Ext.define('Event',{
        extend: 'Ext.data.Model',
				idgen: {
         type: 'sequential',
         seed: 100,
         prefix: 'M' + m + '/'
     },
        fields: [
            // set up the fields mapping into the xml doc
            // The first needs mapping, the others are very basic
            {name: 'n', mapping: '@n'},
						{name: 'time', mapping: '@time'},
						{name: 'length', mapping: '@length'},
						{name: 'c', mapping: '@c', type:'bool' },
						{name: 'lang', mapping: '@lang'},
						{name: 'type', mapping: '@type'},
						{name: 'speaker', mapping: '@speaker'},
						{name: 'props', mapping: '@props'},
						{name: 'textN', mapping: '@textN'},
						{name: 'textF', mapping: '@textF'},
						{name: 'notes', mapping: '@notes'},
						{name: 'commit', mapping: '@commit'},
						{name: 'id', mapping: '@id'}
						
        ]
    });

    // create the Data Store
    var store = Ext.create('Ext.data.Store', {
        model: 'Event',
        autoLoad: true,
				autoSync: false,
        proxy: {
            // load using HTTP
            type: 'ajax',
						api: {
                read: '/exist/rest//db/tullio/' + m + '/events.xml',
                create: '/exist/tullio/xq/logreceiver.xql?o=create&m=' + m,
                update: '/exist/tullio/xq/logreceiver.xql?o=update&m=' + m,
                destroy: '/exist/tullio/xq/logreceiver.xql?o=delete&m=' + m,
            },
            // the return will be XML, so lets set up a reader
            reader: {
                type: 'xml',
								root: 'events',
                record: 'e',
                idProperty: 'id'
            },
						writer: {
                type: 'xml',
                root: 'events',
								record: 'e',
                idProperty: 'id'
            } 
        },
				listeners: {
					beforesync: setCommitStatus
				}
    }); 

		var cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
        clicksToEdit: 1,
				pluginId: 'cellplugin'
    
    });
   
    
    /* 
    create the grid
    */
    var grid = Ext.create('Ext.grid.Panel', {
        store: store,
        sortableColumns: false,
        columns: [
	
						{header: "N.", width: 30, dataIndex: 'n'},
						{header: "Tijd", width: 70, dataIndex: 'time', editor: {
                allowBlank: false
            }},
						{header: "Lengte", width: 50, dataIndex: 'length'},
						{header: "Clip", width: 30, dataIndex: 'c',  
							editor: {
								xtype: 'checkbox',
								cls: 'x-grid-checkheader-editor'
							},
							renderer: function(v) { return v ? 'C' : '';}
						},
						{header: "P", width: 30, dataIndex: 'commit'},
						{header: "Taal", width: 50, dataIndex: 'lang',
							editor: new Ext.form.field.ComboBox({
                typeAhead: true,
                triggerAction: 'all',
                selectOnTab: true,
                store: ['N', 'F', 'M'],
                lazyRender: true,
                listClass: 'x-combo-list-small'
							}),
							renderer: function(v) {
								if (v=='N') return "<span style='color:red'>" + v + "</span>";
								else if (v=='F') return "<span style='color:blue'>" + v + "</span>";
								else if (v=='M') return "<span style='color:green'>" + v + "</span>";
							}
						},
            {header: "Type", flex: 1, dataIndex: 'type', 
							renderer:  function(value) {
								return eventTypesLookup[value] ;
							},
							field: {
                xtype: 'combobox',
                typeAhead: true,
								forceSelection: true,
                triggerAction: 'all',
                selectOnTab: true,
                store: eventTypesDict,
                lazyRender: false,
                listClass: 'x-combo-list-small',
                minWidth: 150
							}
						},
            {header: "Spreker", width: 140, dataIndex: 'speaker', field: {
                xtype: 'combobox',
                typeAhead: true,
								forceSelection: true,
                triggerAction: 'all',
                selectOnTab: true,
                store: allSpeakersDict,
                lazyRender: false,
								minWidth: 200,
                listClass: 'x-combo-list-small'
							
							}},
							{header: "Onderwerp N", width: 180, dataIndex: 'textN', editor: {
								xtype     : 'textareafield',
								grow      : true,
								anchor    : '100%'
								}
							},
            {header: "Onderwerp F", width: 180, dataIndex: 'textF', editor: {
								xtype     : 'textareafield',
								grow      : true,
								anchor    : '100%'
								}
							},
						{header: "Opmerkingen", width: 115, dataIndex: 'notes', editor: {
								xtype     : 'textareafield',
								grow      : true,
								anchor    : '100%'
								}
							}
            
        ],
				selModel: {
            selType: 'cellmodel'
        },
        renderTo:'example-grid',
				width: 960,
        height: 400,
				plugins: [cellEditing],
				dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text: 'Add',
                iconCls: 'icon-add',
                handler: function(){
                    // Create a record instance through the ModelManager
										var timestamp = Ext.Date.format(new Date(), 'H:i:s');
										var event = new Event({
											time: timestamp
										});
										cellEditing.cancelEdit();
										event.setDirty();
										store.insert(0, event);
										//grid.getView().refresh();
										// store.commitChanges();
										
										cellEditing.startEditByPosition({
												row: 0,
												column: 1
										});
										
										//event.commit();
										//store.add(r);
										// cellEditing.startEditByPosition({row: 0, column: 6});
										//r.setDirty();
                }
            }, '-', {
                itemId: 'delete',
                text: 'Delete',
                iconCls: 'icon-delete',
                disabled: false,
                handler: function(){
                    var selection = grid.getView().getSelectionModel().getSelection();
                    if (selection[0].data.commit != 'P' && selection[0].data.commit != 'F') store.remove(selection);
										console.log(selection);
										
                }
            }, '-', {
                itemId: 'insert',
                text: 'Insert',
                iconCls: 'icon-insert',
                disabled: false,
                handler: function(){
										var r = Ext.ModelManager.create({
												Type: 'NEW RECORD',
												Number: 1000,
												Speaker: 'ahoy',
												//availDate: Ext.Date.clearTime(new Date()),
												Language: "F"
										}, 'Event');
                    var selection = grid.getView().getSelectionModel().getSelection();
                    if (selection[0].data.commit != 'P') store.insert(store.indexOf(selection[0]), r);
                }
            }]
        }],
			
				listeners: {
					beforeedit: function(plugin, e, eOpts) {
						console.log(e.record.data.clip);
						return (e.record.data.commit == 'P' || e.record.data.commit == 'F') ? false : true;
						//alert('yyy');
            // if (e.record.get("something") != "whatwerelookingfor") {
            //     return false;
            //}
            // return true;
        }
    }
				
    });
		
		
		function update() {
			console.log('looping');
			updateClipLength(store);
			setTimeout(update, 3000);
		}
		update();
		
		
		$(document).delegate('#agendaplaceholder td','click', function(e) {
					mtype = $(this).siblings().andSelf().filter(".type").text();
					but=e.target.id;
					var submission = {
												 speaker:$(this).siblings().andSelf().filter(".speaker").text(),
												 type: $(this).siblings().andSelf().filter(".type").text(),
												 lang: $(this).siblings().andSelf().filter(".lang").text(),
												 props: $(this).siblings().andSelf().filter(".gov").text(),
												 textN: $(this).siblings().andSelf().filter(".subjectN").text(),
												 textF: $(this).siblings().andSelf().filter(".subjectF").text(),
												 notes: $(this).siblings().andSelf().filter(".short").text(),
												 clip:'true'
					}
					var timestamp = Ext.Date.format(new Date(), 'H:i:s');
					var event = new Event(submission);
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.setDirty();
					store.insert(0, event);
					
					$(this).parent().css('background-color', 'silver');
					return true;
		
		})

		
		
		
		var map = new Ext.util.KeyMap({
    target: grid,
    key: 13,
    fn: function(){ alert('a, b or c was pressed'); },
    scope: grid
		});
		
		var map2 = new Ext.util.KeyMap({
    target: grid,
    eventName: 'itemkeydown',
    binding: {
        key: 13,
        fn: function(){ alert('a, b or c was pressed'); }
    }
		});
		
		var checkUpdate = function(batch, options) {
			console.log('ting ting');
			
			var size = store.getCount();
			var found;
			var record;
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				if (record.data.commit == 'P' || record.data.commit == 'F') break;
				record.setDirty();
			}
			
			
			// add code to make records that are not committed dirty
			
		}
		
		var handleOption1 = function() {
			alert('Sync');
			var fb = '';
			fb = updateClipLength(store);
			if (fb != 'stop') store.sync({callback: checkUpdate});
		};

		var mapggg = new Ext.util.KeyMap(Ext.getDoc(), {
				key: Ext.EventObject.ONE,
				ctrl: true,
				handler: handleOption1
		});
		
		
			
			
			function addToStore(event) {
				console.log('button clicked by ');
				console.log(event.target);
				var timestamp = Ext.Date.format(new Date(), 'H:i:s');
				var event = new Event(propsRegister[event.target.id]);
										cellEditing.cancelEdit();
										event.set('time', timestamp);
										event.setDirty();
										store.insert(0, event);
										//grid.getView().refresh();
										// store.commitChanges();
										
										cellEditing.startEditByPosition({
												row: 0,
												column: 1
										});
				
				
			}
		
			$(".buttons div").bind('click', addToStore); 
			var members = [];
			for (i=0; i<speakers.length; i++)  {
				members[i] = speakers[i][1];
				
			}
			
			
			$( ".tags" ).autocomplete({
									source: function(req, response) {
        var re = $.ui.autocomplete.escapeRegex(req.term);
        var matcher = new RegExp( "^" + re, "i" );
        response($.grep(members, function(item){return matcher.test(item); }) );
        }
			});
			
			$(document).delegate('.b1','click', function(e) {
					
					console.log('confbutton clicked ');
					var conf = $(this).closest('form').find('input').val();
				
					var timestamp = Ext.Date.format(new Date(), 'H:i:s');
					
					var event = new Event();
					
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.set('type', 'new');
					event.set('speaker', conf);
					event.set('lang', langMap[conf]);
					event.set('c', 'true');
					event.setDirty();
					store.insert(0, event);
					cellEditing.startEditByPosition({
							row: 0,
							column: 1
					});
			});
			/*
			$(".b1").bind('click', function(e) {
					
					console.log('confbutton clicked ');
					var conf = $(this).closest('form').find('input').val();
				
					var timestamp = Ext.Date.format(new Date(), 'H:i:s');
					
					var event = new Event();
					
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.set('type', 'new');
					event.set('speaker', conf);
					event.set('lang', langMap[conf]);
					event.set('c', 'true');
					event.setDirty();
					store.insert(0, event);
					cellEditing.startEditByPosition({
							row: 0,
							column: 1
					});
			});
			*/
			// create add / remove functionality for buttons
			
			$(document).delegate("#actionMore", "click", function(){ 
					var lastbutton = $(this).nextAll().last();
					console.log(lastbutton);
					lastbutton.clone().insertAfter(lastbutton);
					$( ".tags" ).autocomplete({
										source: function(req, response) {
											var re = $.ui.autocomplete.escapeRegex(req.term);
											var matcher = new RegExp( "^" + re, "i" );
											response($.grep(members, function(item){return matcher.test(item); }) );
										}	
					});
			});
			
			$(document).delegate("#actionLess", "click", function(){
					if ($(this).nextAll("form").length > 1) $(this).nextAll("form").last().remove();
			});
			
});

