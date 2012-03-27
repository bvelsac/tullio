(function($) {
    $.QueryString = (function(a) {
        if (a == "") return {};
        var b = {};
        for (var i = 0; i < a.length; ++i)
        {
            var p=a[i].split('=');
            if (p.length != 2) continue;
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
        }
        return b;
    })(window.location.search.substr(1).split('&'))
})(jQuery);

// $.QueryString["param"]

var mmm = $.QueryString["m"];
$("#meeting-id").text("Meeting: " + mmm);

function entries2server(){
                  console.log('sending...');  
									var xml = $.json2xml(livedata, options);
									var xml2 = json2xml.convert(livedata, "data");
									
                  console.log(xml);
                    $.ajax({
                        type: "GET",
                        url: "/exist/tullio/xq/receiver.xql",
                        data: {
														meeting: mmm,
                            entries: xml,
                            customData: "bla bla"
                        },
                        dataType: "xml",
                        contentType: "application/xml; charset=utf-8",
                        success: function(response, textStatus, xhr){
                            alert("success");
                        },
                        error: function(xhr, textStatus, errorThrown){
                            alert("error");
                        }
                    });
                }
								
								
								
                   console.log('start synching');
             //        setInterval ( "entries2server()", 2000);
			
			
			
						 // Load agenda
						 
						 
						function loadAgenda() {
							 myAgenda = $("#agenda");
							 console.log(myAgenda);
							 
							 $('#agenda').load('../hello3.xql?m=' + mmm, function() {
							 });
							 
							 
							 
							 
						 }
						 
						 
				//		 $('.send').click(housekeeping());
						 
						 loadAgenda();
						 
			
			// Next block registers a function on the variable buttons (with autocomplete for speakers) -- reads settings and adds a new line to the data grid
			
			$('.send').click(function(e) {
				
										sequencecounter++;

					console.log('submission');
				//	alert('form submit');	
					but=e.target.id;
					var current = new Date().getTime();
					
					var timeDiff = current - time;
					console.log(timeDiff);
					console.log('#' + but + 'newClipInd');
					console.log($('#' + but + 'newClipInd'));
					
					console.log('nci' + $('#' + but + 'newClipInd').val());
					
					
					time = current;
					
					y = sequencecounter > 1 ? toHumanTime(timeDiff) : '';	
					
					lookup=but+'group2';
					console.log(but+'group2');
					
					txt="input[name=" + lookup + "b1group2]:checked";
					
					console.log($('input[name=' + lookup + ']:checked').val());
					
					langSel = ( $('input[name=' + lookup + ']:checked').val() =='N' ? 'NL' : 'FR');
					
					console.log('taal:' + langSel);
					
					var submission = {
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 speaker:$('#' + but + 'tags').val(),
												 type:'new ' + langSel,
												 lang:$('input[name=' + lookup + ']:checked').val(),
												 clip:$('#' + but + 'newClipInd').is(':checked') ? 'true' : ''

					}
					console.log(submission);	
					
												livedata[0].duration = y;
												livedata.unshift(submission);
												livegrid.invalidateAllRows();
												livegrid.updateRowCount();
												livegrid.render();
						
						return false;
					}
);
			
			// Configuration of the autcomplete functionality, will be read from server in the next edition
				
			
			
			var members = [];

function setSpeakers(response) {
		var people = response.getElementsByTagName("person");
    var nP = people.length;
		var j =0;
		var k =0;
		console.log("¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨p" + nP);
		 for (i=0; i<nP; i++) {
			 if (people[i].getAttribute('id')) {
				 // console.log(people[i].getAttribute('id'));
				 // console.log(people[i].getElementsByTagName('first')[0].firstChild.nodeValue);
				 members[j] = people[i].getAttribute('id');
				 j++;
			}
			 
			
		}
	}

	var requestConfig = "/exist/tullio/xml/titles.xml";
	
	jQuery.ajax({
				async: false,
			 	type: "GET",
        url:    requestConfig,
        success: setSpeakers,
				dataType: "xml" 
	 });

console.log(members);
console.log('test');

			
			var availableTags = [
			"BERTIEAUX Françoise",
"AMPE Els",
"BROTCHI Jacques.",
"COPPENS René",
"COLSON Michel",
"DEJONGHE Carla",
"d'URSEL Anne-Charlotte",
"MENNEKENS Herman",
"DE BOCK Emmanuel",
"de CLIPPELE Olivier",
"de PATOUL Serge",
"DE WOLF Vincent",
"AHIDAR Fouad",
"DESTEXHE Alain",
"BROUHON Sophie",
"DRAPS Willem",
"ROEX Elke",
"FRAITEUR Béatrice",
"VAN DAMME Jef",
"GOSUIN Didier",
"JODOGNE Cécile",
"LEMESRE Marion",
"MANDAILA Gisèle",
"DEBAETS Bianca",
"MOLENBERG Isabelle",
"DE PAUW Brigitte",
"PAYFA Martine",
"VANDENBOSSCHE Walter",
"PERSOONS Caroline",
"PIVIN Philippe",
"ROUSSEAUX Jacqueline",
"SCHEPMANS Françoise",
"LOOTENS-STAEL Dominiek",
"SIDIBE Fatoumata",
"TEITELBAUM Viviane",
"VAN GOIDSENHOVEN Gaëtan",
"MAES Annemie",
"AZZOUZI Mohamed",
"VAN DEN BRANDT Elke",
"BOUARFA Sfia",
"CARTHE Michèle",
"CHAHID Mohammadi",
"CLOSE Philippe",
"DE RIDDER Paul",
"DAÏF Mohamed",
"DESIR Caroline",
"DIALLO Bea",
"DUPUIS Françoise",
"DEMOL Johan",
"EL KTIBI Ahmed",
"VAN LINTER Greet",
"EL YOUSFI Nadia",
"HUTCHINSON Alain",
"IKAZBAN Jamal",
"MOUREAUX Catherine",
"MOUZON Anne Sylvie",
"OURIAGHLI Mohamed",
"ÖZKARA Emin",
"P'TITO Olivia",
"THIELEMANS Freddy",
"TOMAS Eric",
"VERVOORT Rudi",
"ALBISHARI Aziz",
"BRAECKMAN Dominique",
"DEFOSSE Jean-Claude",
"DELFORGE Céline",
"DIRIX Anne",
"HERSCOVICI Anne",
"KHATTABI Zakia",
"LURQUIN Vincent",
"MARON Alain",
"MOREL Jacques",
"MOUHSSIN Ahmed",
"NAGY Marie",
"PESZTAT Yaron",
"PINXTEREN Arnaud",
"TRACHTE Barbara",
"VANHALEWYN Vincent",
"CARON Danielle",
"de GROOTE Julie",
"DOYEN Hervé",
"du BUS de WARNAFFE André",
"EL KHANNOUSS Ahmed",
"FASSI-FIHRI Hamza",
"FREMAULT Céline",
"MAMPAKA MANKAMBA Bertin",
"MIGISHA Pierre",
"OZDEMIR Mahinur",
"RIGUELLE Joël "
		];
		$( ".tags" ).autocomplete({
									source: function(req, response) {
        var re = $.ui.autocomplete.escapeRegex(req.term);
        var matcher = new RegExp( "^" + re, "i" );
        response($.grep(members, function(item){return matcher.test(item); }) );
        }
		});

			
		// Utility function to convert the time interval between two events into minutes and seconds
		
		
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
		test = toHumanTime(10000);
		console.log(test);
		
		
		// grid setup
		
		function requiredFieldValidator(value) {
			if (value == null || value == undefined || !value.length)
				return {valid:false, msg:"This is a required field"};
			else
				return {valid:true, msg:null};
		}
/*
		nr
		time
		duration
		clip
		lang
		type
		speaker
		props
		notes
	*/	
		
		
		var sequencecounter = 0;
		var time;
	
		var livegrid;
		var livedata = [];
		var columns = [
			{id:"nr", name:"NR", field:"nr", width:30, cssClass:"event-nr", editor:TextCellEditor, validator:requiredFieldValidator},
      {id:"time", name:"Tijd", field:"time", width:60, editor:TextCellEditor},
      {id:"duration", name:"Duration", field:"duration"},
			{id:"clip", name:"C", field:"clip", width:30, formatter:BoolCellFormatter, editor:YesNoCheckboxCellEditor},
			{id:"lang", name:"Taal", field:"lang", width:30, resizable:false, editor:LangSelectCellEditor},
			{id:"type", name:"Type", field:"type", width:100, editor:TextCellEditor},
			{id:"speaker", name:"Spreker", field:"speaker", width:150, editor:TextCellEditor},
			{id:"gov", name:"Regering", field:"gov", width:120},
			{id:"textN", name:"Onderwerp", field:"textN", width:120},
			{id:"textF", name:"Sujet", field:"textF", width:120},
			{id:"notes", name:"Opmerkingen", field:"notes", width:150, editor:TextCellEditor},
			{id:"committed", name:"Verzonden", field:"committed", width:30}
		];
		var options = {
			editable: true,
			enableAddRow: true,
			enableCellNavigation: true,
			asyncEditorLoading: false,
      autoEdit: true
		};

		$(function()
		{
			
			
			livedata[0] = {
				nr:'0',
				time:'',
				duration:'',
				clip:'',
				lang:'',
				type:'',
				speaker:'',
				props:'',
				notes:'',
				committed:''
			};

			livegrid = new Slick.Grid("#livegrid", livedata, columns, options);

            //grid.registerPlugin(new Slick.CellRangeSelector());

            livegrid.setSelectionModel(new Slick.CellSelectionModel());

            livegrid.onAddNewRow.subscribe(function(e, args) {
								alert('help');
                var item = args.item;
                var column = args.column;
                livegrid.invalidateRow(data.length);
                livedata.push(item);
                livegrid.updateRowCount();
                livegrid.render();
            });
						
			
						
				

						
						
						
		})
		
		
		$("#commit").click( function(){
				console.log('housekeeping');
				
				// moet eerst een clipstart vinden, dat is de laatste nieuwe
				// alles wat daarna komt mag worden doorgestuurd
				
				var c1 = ''; 
				
				for (var i = 0; i < livedata.length; i++) {
					console.log(livedata[i].time + " " + livedata[i].nr);
					if (livedata[i].clip  && livedata[i].lang != undefined && c1 == '' ) {
						c1 = "o";
					}
					else if (c1 == "o") {
						livedata[i].committed='X';	
						
					}
					
        }
				
				entries2server();
				livegrid.setData(livedata);
				livegrid.render();
		});
		
		
		
		
		
		
		
		
		// buttons setup: registers event types on the buttons
		
		
		
			$(".buttons div").click(function(event){
					sequencecounter++;
					//props = propsRegister[event.target.id];
					console.log(dateFormat());
					
					var current = new Date().getTime();
					
					
					
					var timeDiff = current - time;
					console.log(timeDiff);
					time = current;
					
					y = sequencecounter > 1 ? toHumanTime(timeDiff) : '';	
					
					var propsRegister = {
						"new clip":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 type:event.target.id
					},
						"open BHP":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 type:event.target.id
					},
						"open VVGGC":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 type:event.target.id
					},
						"suspend BHP":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'',
												 type:event.target.id
					},
						"suspend VVGGC":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},
						"close BHP":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},
						"close VVGGC":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},
						"in NL":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:event.target.id
					},
						"in FR":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:event.target.id
					},
						"new NL":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:event.target.id
					},
						"new FR":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:event.target.id
					},
					"pres":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:"PRES"
					},"app":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},"remarks":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},"jumble":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},"noise":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},"laughter":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},
					"agenda":
					{
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 type:event.target.id
					},
					"huytNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'HUYTEBROECK_Evelyne'
					},
					"cerexNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'CEREXHE_Benoît'
					},
					"grouwNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'GROUWELS_Brigitte'
					},
					"vraesNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'VANHENGEL_Guy'
					},
					"kirNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'KIR_Emir'
					},
					"lilleNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'DE_LILLE_Bruno'
					},
					"doulkNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'DOULKERIDIS_Christos'
					},
					"picqueNL":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'N',
												 type:'newNL',
												 speaker:'PICQUE_Charles'
					},
					"huytFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'HUYTEBROECK_Evelyne'
					},
					"cerexFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'CEREXHE_Benoît'
					},
					"grouwFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'GROUWELS_Brigitte'
					},
					"vraesFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'VANHENGEL_Guy'
					},
					"kirFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'KIR_Emir'
					},
					"lilleFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'DE_LILLE_Bruno'
					},
					"doulkFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'DOULKERIDIS_Christos'
					},
					"picqueFR":
					{
												 nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 clip:'true',
												 lang:'F',
												 type:'newFR',
												 speaker:'PICQUE_Charles'
					}
					
			};
					
												// add to grid
												livegrid.invalidateRow(livedata.length);
												livedata[0].duration = y;
												livedata.unshift(propsRegister[event.target.id]);
												livegrid.invalidateAllRows();
												livegrid.updateRowCount();
												livegrid.render();
												
												
                    });
			
			
			
			//$(".filter").click(housekeeping);
		
			// next function will sync data with server
			
			var agendarows = $('.agenda');
			console.log(agendarows);
//			alert(agendarows);
			$('.agenda td').live("click", function(e) {
					//alert('test');
					mtype = $(this).siblings().andSelf().filter(".type").text();
					//copy from agenda
									 sequencecounter++;

					console.log(mtype);
					
				//	alert('form submit');	
					but=e.target.id;
					var current = new Date().getTime();
					
					var timeDiff = current - time;
					console.log(timeDiff);
					console.log('new from agenda');
					
					time = current;
					
					y = sequencecounter > 1 ? toHumanTime(timeDiff) : '';	
					
					
					// txt="input[name=" + lookup + "b1group2]:checked";
					
					// console.log($('input[name=' + lookup + ']:checked').val());
					
					// langSel = ( $('input[name=' + lookup + ']:checked').val() =='N' ? 'NL' : 'FR');
					
					// console.log('taal:' + langSel);
					
					
					
					
					var submission = {
					               nr:sequencecounter,
												 time:dateFormat('isoTime'),
												 speaker:$(this).siblings().andSelf().filter(".speaker").text(),
												 // speaker:$('#' + but + 'tags').val(),
												 type: $(this).siblings().andSelf().filter(".type").text(),
												  lang: $(this).siblings().andSelf().filter(".lang").text(),
												 gov: $(this).siblings().andSelf().filter(".gov").text(),
												 textN: $(this).siblings().andSelf().filter(".subjectN").text(),
												 textF: $(this).siblings().andSelf().filter(".subjectF").text(),
												 notes: $(this).siblings().andSelf().filter(".short").text(),
												 clip:'true'
					}
					console.log(submission);	
					
												livedata[0].duration = y;
												livedata.unshift(submission);
												livegrid.invalidateAllRows();
												livegrid.updateRowCount();
												livegrid.render();
												
					$(this).parent().css('background-color', 'silver');
						
						return true;
									 
									 
									 
									 
								 
								 
								 
								 
								 
									 
									 // end copy
					
					
					
			});
			
