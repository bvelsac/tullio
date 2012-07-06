/*
  
Tullio

JS for Logger 

Grid based on Ext JS 4

http://www.sencha.com/

GNU General Public License Usage
This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.

*/
// pixelbreedte 900 voor logger 400 voor agenda

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

var backstep = 2000;
var offset = 0;
var store;		
var batch = 0;
var channel = "";
var extra = '';

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

function setOffset() {
			var dateStr;
			var random = new Date().getTime();
			var newOffset = 'none';
			$.ajax({
					type: 'GET',
					url:'/exist/tullio/newlogger/time.html?request=' + random,
					success: function(data, textStatus, XMLHttpRequest){
									dateStr = XMLHttpRequest.getResponseHeader('Date');
									var serverTimeMillisGMT = Date.parse(new Date(Date.parse(dateStr)).toUTCString());
									var localMillisUTC = Date.parse(new Date().toUTCString());
									newOffset = serverTimeMillisGMT -  localMillisUTC;
									console.log(newOffset);
			
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						
						console.log("time sync error");
					},
					async: true
			});
			
			if (newOffset != 'none') { offset = newOffset ; }
			
			return newOffset;
		
		}		



		function runAdjust() {
			setOffset();
			
			t = setTimeout("runAdjust()", 60000);
					console.log('OFFSET: '+ offset);
		}
		
		
		function runClocks() {
			// display real time
			
			var ltimestamp = new Date();
			ltimestamp.setTime(ltimestamp.getTime() + offset);
			ltimestamp = Ext.Date.format(ltimestamp, 'H:i:s');
			$('#clock').text(ltimestamp);
			var lastClip;
			
			// display timelapse since last clipmarker
			
			// lookup timestamp of last marker
			var size;
			if ( typeof store != "undefined" ) {size = store.getCount(); }
			if ( size > 0 ) {
				// loop through the records, starting with most recent record
				for (i=0; i < size; i++) {
					record = store.getAt(i);
				
					if (record.data.c) {
						// console.log('clip');
						
						var now = new XDate();
						now.setTime(now.getTime() + offset);
						now = Ext.Date.format(now, 'H:i:s');
						var ref = new XDate("2011-09-05T" + now);
						
						var current = new XDate("2011-09-05T" + record.data.time);
						var diff = ref - current;
						$('#timer').text(toHumanTime(diff));
						//console.log("timer: " + diff);
						if (diff > 210000 && diff < 300000) {
							$('#timer').addClass('runningLate');
						}
						else {
							$('#timer').removeClass('runningLate');
						}
						
						if (diff > 300000) {
							$('#timer').addClass('veryLate');
						}
						else {
							$('#timer').removeClass('veryLate');
						}
						break;
					}
				}
			}
			
			
			// wait one second
			
			setTimeout ("runClocks()", '1000');
			
		}


$(document).ready(function() {
		


});



// http://localhost:8080/exist/rest//db/tullio/2012-03-29-AM_COMM-ECO/events.xml

Ext.onReady(function(){
		 $(document).delegate('div.chatbutton','click', function(e) {
			$('div.chat').toggle();

		});
		


		var m = $.QueryString["m"];
		var lang = $.QueryString["lang"];
		console.log(m + lang);
		console.log(eventTypes[lang]);
		var counter;
		
		// align with server time
		
		console.log('OFFSET: '+ offset);
		runAdjust();
		
		// start displaying clocks
		runClocks();
		
		var meetingId = "";
		
		meetingId += m.substr(0,4);
		meetingId += m.substr(5,2);
		meetingId += m.substr(8,2);
		
		if ( m.indexOf('PLEN') != -1 ) {
			meetingId += "10";
		}
		else if ( m.indexOf('COM-AEZ') != -1 ) {
			meetingId += "11";
		}
		
		else if ( m.indexOf('COM-AIBZ') != -1 ) {
			meetingId += "12";
		}
		
		else if ( m.indexOf('COM-ATRO') != -1 ) {
			meetingId += "13";
		}
		
		else if ( m.indexOf('COM-ENVMIL') != -1 ) {
			meetingId += "14";
		}
		
		else if ( m.indexOf('COM-FIN') != -1 ) {
			meetingId += "15";
		}
		
		else if ( m.indexOf('COM-INFRA') != -1 ) {
			meetingId += "16";
		}
		
		else if ( m.indexOf('COM-LOGHUIS') != -1 ) {
			meetingId += "17";
		}
		
		else if ( m.indexOf('ASSZSANGEZ') != -1 ) {
			meetingId += "18";
		}
		
		else if ( m.indexOf('ASSZ') != -1 ) {
			meetingId += "19";
		}
		
		else if ( m.indexOf('SANGEZ') != -1 ) {
			meetingId += "20";
		}
		else if ( m.indexOf('PFB') != -1 ) {
			meetingId += "21";
		}
		else {
			meetingId += "22";
		}
		var random = Math.floor(Math.random()*1001);
		// meetingId += random;
		console.log("ID:" + meetingId);
		
		// load agenda
		$('#agendaplaceholder').load('/exist/tullio/newlogger/hello3.xql?m=' + m, function() {});
		
		// code for meeting room selection
		
		var channels = {1: 'S 201', 2: 'S 206', 3: 'Hemicycle / halfrond'};
		
		var audioMap = {'Hemicycle / halfrond':'canal1', 'S 201':'canal3', 'S 206':'canal4'};
		var meetingList = {};
		
		
		$.ajax({
					type: 'GET',
					url:'/exist/tullio/xq/meetinglist.xql',
					success: function(data, textStatus, XMLHttpRequest){
						var list = data.getElementsByTagName("item");
						var nI = list.length;
						for (i=0; i<nI; i++) {
							meetingList[i]=list[i].firstChild.nodeValue;
						}
						console.log(nI);
						console.log(data);
						console.log(meetingList);
						console.log(channels);
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
					},
					async: false
			});
		
		
		function end(content){
alert(content.current+':'+content.previous)
}
		
/*
		$('#channel').editable('/exist/tullio/xq/setChannel.xql?m=' + m, { 
     data   : "{'PLEN':'PLEN','S 201':'S 201','S 204':'S 204', 'selected':'S 204'}",
     type   : 'select',
     submit : 'OK'
 });
		*/
		
		$("#channel.editable_select").editable("/exist/tullio/xq/setChannel.xql?m=" + m, { 
				data   : "{'canal1':'PLEN','canal3':'S 201','canal4':'S 204'}",
    type   : "select",
    submit : "OK",
    style  : "inherit"
  });

		
		$('#agenda2').editable(function(value, settings) { 
				console.log(this);
				console.log(value);
				console.log(settings);
				$('#agendaplaceholder2').load('/exist/tullio/newlogger/hello3.xql?m=' + settings.data[value]);
				extra = settings.data[value];
				return(settings.data[value]);
		}, { 
				type:'select',
        data: meetingList,
        submit:'OK'
		});
		/*
		$('#agenda2').editable({
                    type:'select',
                    data: meetingList,
                    submit:'OK',
                    cancel:'Cancel',
                    onSubmit: function(content) {
												$('#agendaplaceholder2').load('/exist/tullio/newlogger/hello3.xql?m=' + content.current, function() {});
											console.log(content);
										}
                   });
		*/
		
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
		
		// logger grid prevents inserting, deleting committed entries
		// numbering of committed entries cannot be updated
		
		
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
			console.log("u c l ");
			
			store.suspendAutoSync();
			
			if (store.getCount() < 2) return;
			
			var size = store.getCount();
			var moreRecent = "";
			var record;
			var langMem;
			var rowType = 'odd';
			var view = 	grid.getView();
			
			
			// addRowCls( HTMLElement/String/Number/Ext.data.Model rowInfo, String cls )
			// removeRowCls
			// set language for all events
			// console.log(store.getAt(size-1).data.lang);
			if (size > 3 && ( store.getAt(size-1).data.lang == "" || store.getAt(size-1).data.lang == undefined) ) {
				alert("Set language for first record"); return "stop";
			}
			
			if (size > 3 && ( store.getAt(size-1).data.c == "" || store.getAt(size-1).data.c == undefined )) {
				alert("First record is not a clip"); return "stop";
			}
			/*
			.x-grid-row td {
    background: white !important;
    	.x-grid-row.odd td
    	
    .x-grid-row-alt .x-grid-cell, .x-grid-row-alt .x-grid-rowwrap-div {
    background-color: #FAFAFA;
}
}
*/
				// loop through the records, starting with oldest record
			for (i=size-1; i >= 0; i--) {
				record = store.getAt(i);
				
				record.set('id', size - i);
				
				if ( record.data.c ) {
					rowType = (rowType=='odd') ? 'even' : 'odd' ; 
				}
				view.removeRowCls( record, 'odd' )
				view.removeRowCls( record, 'even' )
				view.addRowCls( record, rowType )
				
				if (record.data.lang == "" || record.data.lang == undefined) {
					record.set('lang', langMem);
				}
				else {langMem = record.data.lang;}
				
				
				
			}
			
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				//record.set('id', i );
				// console.log(record.data.time + 'L::' + record.data.length);
				
				
				
				
				if (record.data.c) {
					// console.log('clip');
					var current = new XDate("2011-09-05T" + record.data.time);
					if (moreRecent != '') {
						var diff = moreRecent - current;
						record.set('length', toHumanTime(diff));
						// console.log('length set' + toHumanTime(diff));
					}
					moreRecent = current;
				}
				else {
					record.set('length', '');
				}
			}
			
			store.resumeAutoSync();

		}
		
		function setCommitStatus(options, eOpts) {
			console.log('publish');
			store.suspendAutoSync();
	

			var size = store.getCount();
			var found = "";
			var record;
			console.log(size);
			// loop through the records, starting with most recent record
			for (i=0; i < size; i++) {
				record = store.getAt(i);
				//console.log(i);
				//console.log(record);
				if (record.data.commit == 'P') break;
				if (found == "clip") {record.set('commit', 'P')};
				if (record.data.c && found !='clip') {
					found = "clip"; 
					record.set('commit', 'F');
					
				} 
			}
			console.log('commit');
			store.sync();
			store.resumeAutoSync();
			// console.log(options);
			// console.log(eOpts);
			// console.log(store);
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
        extend: 'Ext.data.Model'
				/*,
				
				idgen: {
         type: 'sequential',
         seed: 100,
				 prefix : meetingId
				 
     }*/,
        fields: [
            // set up the fields mapping into the xml doc
						
						/*
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
						*/
						{name: 'id', type: 'integer'},
						{name: 'n'},
						{name: 'time'},
						{name: 'length'},
						{name: 'c', type:'bool' },
						{name: 'lang'},
						{name: 'type'},
						{name: 'speaker'},
						{name: 'props'},
						{name: 'textN'},
						{name: 'textF'},
						{name: 'notes'},
						{name: 'commit'}
						//,
						
        ]
    });

    // create the Data Store
    store = Ext.create('Ext.data.Store', {
        model: 'Event',
        autoLoad: true,
				autoSync: false,
				batchUpdateMode : 'operation',
				proxy: {
					type: 'localstorage',
					id: m
				},
				/*
        proxy: {
            // load using HTTP
            type: 'ajax',
						api: {
                read: '/exist/rest/tullio/xq/reverseEvents.xql?m=' + m,
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
				*/
				listeners: {
					beforesync: function () {
							
						 updateClipLength(store);
						 
					
					
					}
				}
    }); 
		
		store.sort('id', 'DESC');
		
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
							{header: "Clip", width: 30, dataIndex: 'c',
							xtype: 'checkcolumn',
							/*
							listeners : {
								
								
							}
							
							beforecheckchange : function (column,rowindex) {
								alert('test');
								console.log(rowindex);
								console.log(store.getAt(rowindex));
							}
							*/
							/*
							,
							editor: {
								xtype: 'checkbox',
								cls: 'x-grid-checkheader-editor'
							},
							renderer: function(v) { return v ? 'C' : '';}
							*/
						},
						{header: "P", width: 30, dataIndex: 'commit'},
/*						{header: "N.", width: 30, dataIndex: 'n'},*/
						{header: "Tijd", width: 70, dataIndex: 'time', editor: {
                allowBlank: false
            }},
						{header: "Lengte", width: 50, dataIndex: 'length'},

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
            
            {header: "Spreker", width: 140, dataIndex: 'speaker', field: {
                xtype: 'combobox',
                typeAhead: true,
								forceSelection: false,
                triggerAction: 'all',
                selectOnTab: true,
                store: allSpeakersDict,
                lazyRender: false,
								minWidth: 200,
                listClass: 'x-combo-list-small'
							
							}},
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
						{header: "Opmerkingen", width: 115, dataIndex: 'notes', editor: {
								xtype     : 'textareafield',
								grow      : true,
								anchor    : '100%'
								}
							},
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
							}
            
        ],
				selModel: {
            selType: 'cellmodel'
        },
        renderTo:'example-grid',
				width: 1100,
        height: 450,
				plugins: [cellEditing],
				dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text: 'Add',
                iconCls: 'icon-add',
                handler: function(){
                    // Create a record instance through the ModelManager
										
										var timestamp = new Date();
										timestamp.setTime(timestamp.getTime() + offset - backstep);
										timestamp = Ext.Date.format(timestamp, 'H:i:s');
										
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
												column: 5
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
									var r = Ext.ModelManager.create({}, 'Event');
                    var selection = grid.getView().getSelectionModel().getSelection();
                    if (selection[0].data.commit != 'P') store.insert(store.indexOf(selection[0]), r);
                }
            }, '-', {
                itemId: 'publish',
                text: 'Publish',
                iconCls: 'icon-publish',
                disabled: false,
                handler: function(){
									
									var fb = '';
									fb = updateClipLength(store);
									// to do before submitting the clips
									// 
									// make a list of the clips that need to be submitted ()
									
									// calculate the clip language code of unsubmitted clips => done at server side, takes the language of the clip event
									
									// to do after submitting the clips
									// downgrade publication status if request failed
									
									if (fb != 'stop') {
										/*
										if (confirm('Publish clips ?')) store.sync( {callback: checkUpdate} )
										*/
										if (confirm('Publish clips ?')) {
											
											console.log('publish');
											store.suspendAutoSync();

											var size = store.getCount();
											var found = "";
											var record;
											var newClips = [];
											batch++;
											var breakpoint = "INIT";
											
											console.log(size);
											// loop through the records, starting with most recent record
											for (i=0; i < size; i++) {
												breakpoint = i;
												record = store.getAt(i);
												//console.log(i);
												//console.log(record);
												if (record.data.commit == 'P') break;
												if (found == "clip") {record.set('commit', 'P')};
												if (record.data.c && found !='clip') {
													found = "clip"; 
													record.set('commit', 'F');
												} 
												newClips.push(record.data);
												
											}
											var xmlDump = x2js.json2xml_str(newClips);
											xmlDump = xmlDump.replace(/<([0-9]+)>/g, "<e b='" + batch + "' row='$1'>");
											xmlDump = xmlDump.replace(/<(\/)([0-9]+)>/g, "</e>");
											xmlDump = "<records meeting='" + m + "'>" + xmlDump + "</records>";
												
											console.log(xmlDump);
											
											
											function resetClips(breakpoint) {
												if (breakpoint != 'INIT') {
													for (i=0; i<breakpoint; i++) {
																store.getAt(i).set('commit', '');
													}
													store.getAt(breakpoint-1).set('commit', 'F');
												}
											};
											
											
											$.ajax({
													type: 'POST',
													url: "/exist/tullio/xq/logreceiver.xql?m=" + m,
													data:  xmlDump,
													contentType: 'text/xml',
													processData: false,
													async: false,
													error : function (request, status, error) {
														console.log('commit error ocurred');
														console.log(status);
														console.log(error);
														resetClips(breakpoint);
													}
											}).done(function( msg ) {
												console.log(msg);
											});
											
											console.log('commit');
			
											store.sync();
											store.resumeAutoSync();
											
											
											
											
										}
									}


									
								}
            }]
        }],
			
				listeners: {
					beforeedit: function(plugin, e, eOpts) {
						// console.log(e.record.data.clip);
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
			// console.log('looping');
			updateClipLength(store);
			store.sync();
			setTimeout(update, 5000);
		}
		update();
		
		$(document).delegate('#agendaplaceholder h2','dblclick', function(e) {
				console.log('reload agenda');
				$('#agendaplaceholder').load('/exist/tullio/newlogger/hello3.xql?m=' + m, function() {});
		
				
		});
				$(document).delegate('#agendaplaceholder2 h2','dblclick', function(e) {
				console.log('reload agenda');
				$('#agendaplaceholder2').load('/exist/tullio/newlogger/hello3.xql?m=' + extra, function() {});
		
				
		});
		
		
				
		$(document).delegate('.agendafunc td','click', function(e) {
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
												 c:'true'
					}
					var timestamp = new Date();
					timestamp.setTime(timestamp.getTime() + offset - backstep);
					timestamp = Ext.Date.format(timestamp, 'H:i:s');
					var event = new Event(submission);
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.setDirty();
					store.insert(0, event);
					
					$(this).parent().css('background-color', 'silver');
					return true;
		
		})
		/* keycodes
		f9	 120
		f10	 121
		f11	 122
		f12	 123
		*/
		
		var mapF11 = new Ext.util.KeyMap(Ext.getDoc(), {
				// F11 voegt een nieuwe regel toe, is geen clip
				key: 122,
				fn: function(key, e) {
					e.preventDefault();
					var timestamp = new Date();
					timestamp.setTime(timestamp.getTime() + offset - backstep);
					timestamp = Ext.Date.format(timestamp, 'H:i:s');
					var event = new Event();
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.setDirty();
					store.insert(0, event);
					cellEditing.startEditByPosition({
						row: 0,
						column: 5
					});
					// prevent event propagation
					e.stopPropagation();
															
					return false;
				}
		});
		
		var mapF12 = new Ext.util.KeyMap(Ext.getDoc(), {
				// F11 voegt een nieuwe regel toe, is een clip
				key: 123,
				fn: function() {
					var timestamp = new Date();
					timestamp.setTime(timestamp.getTime() + offset);
					timestamp = Ext.Date.format(timestamp, 'H:i:s');
					var event = new Event();
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.set('c', true);
					event.setDirty();
					store.insert(0, event);
					cellEditing.startEditByPosition({
						row: 0,
						column: 5
					});
															
					return true;
				}
		});
		
		
		
		
		
		var map = new Ext.util.KeyMap({
				target: grid,
				key: 120,
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
			
			var fb = '';
			fb = updateClipLength(store);
			if (fb != 'stop') {alert('Sync'); store.sync({callback: checkUpdate});}
		};

		var mapggg = new Ext.util.KeyMap(Ext.getDoc(), {
				key: Ext.EventObject.ONE,
				ctrl: true,
				handler: handleOption1
		});
		
		
			
			
			function addToStore(event) {
				console.log('button clicked by ');
				console.log(event.target);
				var timestamp = new Date();
				timestamp.setTime(timestamp.getTime() + offset - backstep);
				timestamp = Ext.Date.format(timestamp, 'H:i:s');
				var event = new Event(propsRegister[event.target.id]);
										cellEditing.cancelEdit();
										event.set('time', timestamp);
										
										
										// if ()
										
										
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
			for (i=0; i<allSpeakers.length; i++)  {
				members[i] = allSpeakers[i][1];
				
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
					var timestamp = new Date();
					timestamp.setTime(timestamp.getTime() + offset - backstep);
					timestamp = Ext.Date.format(timestamp, 'H:i:s');
					
					var event = new Event();
					
					cellEditing.cancelEdit();
					event.set('time', timestamp);
					event.set('type', 'new');
					event.set('speaker', conf);
					event.set('lang', langMap[conf]);
					event.set('c', 'false');
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
				
					var timestamp = Ext.Date.format(timestamp, 'H:i:s');
					
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

