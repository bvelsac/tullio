/* load user data */
var user;
var userLang;
var saveActions = 0;
var checkSession = function () {
  // console.log ('check');
  $.ajax({
    url: '/exist/tullio/xq/checksession.xql',
    dataType: 'xml',
    async: false,
    success: function (data) {
      // console.log (data);
      // console.log ($(data).find('success'));
      if ($(data).find('success')[0] != null) {
        user = data.getElementsByTagName("user")[0].getAttribute('id');
        userLang = data.getElementsByTagName("user")[0].getAttribute('lang');
        // console.log (user + userLang);
        return true;
      } else redirectLogin();
    }
  });
  // console.log ('finished');
}

  function redirectLogin() {
    alert("Please log in");
    window.location = '/exist/tullio/xq/login.xql';
  }
checkSession();
(function ($) {
  $.QueryString = (function (a) {
    if (a == "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i) {
      var p = a[i].split('=');
      if (p.length != 2) continue;
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
  })(window.location.search.substr(1).split('&'))
})(jQuery);

var meetingName = $.QueryString["m"];
var typesForDropdown = ['---', 'OUV-OPE', 'O-BXL', 'O-ARVV',  'PRES', 'EXC-AFW', 'COMM-MED', 'GEN-ALG', 'ORA-SPR', 'P.E.CONS-INOVERW','START-MV', 'START-INT', 'START-DV', 'QO-MV', 'QO-MV JOINTE',  'QA-DV', 'QA-DV JOINTE', 'INT', 'INT JOINTE', 'VOTE','FIN-EINDE'];		


var meeting = "";


// code for text parsing in a  separate file


var gov = [];

government.forEach(function(val, i) {
		gov[i] = {id:val[1], name:val[0]};
});

   
var members = [];
speakers.forEach(function(val, i) {
		members [i] = {value:val[1], label:val[0]};
});
console.log(JSON.stringify(members));
		
// config is a js hash that takes as a key the identifiers specified in the -pantsName, and as a value the data structure that must be used to configure the input functionality of the cell 		
				
var config = {
    'event': typesForDropdown,
lang: ['-', 'F', 'N'],
//'type' : eventTypes[userLang],
        'speaker': members,

        'gov': gov
};

var nameTest = new RegExp("-pantsName-([^ ]+)");
var typeTest = new RegExp("\-pantsType\-([^ ]+)");
















$(document).ready( function() {

	
		 $( "#dialog" ).dialog({
autoOpen: false,
width: 1600,
show: {
effect: "blind",
duration: 1000
},
hide: {
effect: "explode",
duration: 1000
},
buttons: [ 
		{ text: "CONVERT", click: function() {
						launchConversion(); 
						
				} 
		} 
					]
});
		
		 
		
    $("#datepicker").datepicker({dateFormat: 'yy-mm-dd'});
    


/*
    $("#convert").click(function () {

        var struc1 = parseInput($("#inputFR").val(), 'F', agendaArray1);
        var struc2 = parseInput($("#inputNL").val(), 'N', agendaArray2);
        console.log(JSON.stringify(agendaArray1));
         console.log(JSON.stringify(agendaArray2));
        var agenda = merge(struc1, struc2);
    });


*/

$(document).on("click", ".delete", function (event) {

    $(this).parents("tr").remove();
});


$(document).on("click", "#add", function (event) {

    addRow(this);
});

$(document).on("click", "#convert", function (event) {

		$( "#dialog" ).dialog( "open" );
	
		
		

});

  $(document).on("click", "#saveAs", function (event) {
        // display the interface to assign a name is visible           
        $("#metadata").toggle(true);
            meetingName = $("#datepicker").val() + "-" + $("#time option:selected").val() + "_" + $("#meeting-type option:selected").val() + "_" + $("#addText").val();
            
            console.log(meetingName);
        if ($("#datepicker").val() == "") {alert ('No date'); return false;}
         $("div#agenda table").attr("data-pants-meeting", meetingName);
var basicInput = JsonML.toXMLText(JsonML.fromHTML(document.getElementById('agenda')));		
		console.log(basicInput);			
		$.transform({error:onError, success:storeDoc, xmlstr:basicInput, xsl:"htmlCleanup.xsl"});	        
        
        
        
                   });
  
  $(document).on("click", "#save", function (event) {
		 if (typeof meetingName == 'undefined') {
		 	 
		 	 
		 	 
		 	 
		 alert("Please enter a name.");
		 return false;
		 
		 }
            
            console.log(meetingName);
   
   
     $("div#agenda table").attr("data-pants-meeting", meetingName);
		var basicInput = JsonML.toXMLText(JsonML.fromHTML(document.getElementById('agenda')));		
		console.log(basicInput);			
		$.transform({error:onError, success:storeDoc, xmlstr:basicInput, xsl:"htmlCleanup.xsl"});		
	/*
		$("#saveMessage").toggle();
		 $( "#saveMessage" ).animate({
backgroundColor: "#aa0000",
color: "#fff",
width: 500
}, 1000 );
				  $( "#saveMessage" ).animate({
backgroundColor: "#fff",
color: "#000",
width: 240
}, 1000 );
			$("#saveMessage").toggle();
		*/
		
});


// store dropdown data
$(document).on("change", "td select", function (event) {
		
var cell = $(this).parent("td");
  var laVa = {
  data: {
  	  label: $(this).children("option:selected").text(),
  	  value : $(this).val()
  	  }
  };
   cell.children("data").remove();
   cell.append(x2js.json2xml_str(laVa));
  cell.attr('data-pants', $(this).val());
  


});



    // now initialize the table
    // check what to do...
    var tabledata = '<TABLE> <TR> <TD class="-pantsName-event -pantsType-dropdown" data-pants="ORA-SPR"/> <TD class="-pantsName-textn -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-textf -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="keywords -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-speaker -pantsType-autocomplete"/> <TD class="-pantsName-gov -pantsType-tags" data-pants=\'[{\"id\":\"4\", \"name\":\"54585\"}]\'/> <TD class="-pantsType-commands"/> </TR> <TR> <TD class="-pantsName-event -pantsType-dropdown"/> <TD class="-pantsName-textn -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-textf -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="keywords -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-speaker -pantsType-autocomplete"/> <TD class="-pantsName-gov -pantsType-tags"/> <TD class="-pantsType-commands"/> </TR> <TR> <TD class="-pantsName-event -pantsType-dropdown"/> <TD class="-pantsName-textn -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-textf -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="keywords -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-speaker -pantsType-autocomplete" data-pants="testsp1"/> <TD class="-pantsName-gov -pantsType-tags"/> <TD class="-pantsType-commands"/> </TR> <TR> <TD class="-pantsName-event -pantsType-dropdown" data-pants="QA-DV"/> <TD class="-pantsName-textn -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-textf -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="keywords -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-speaker -pantsType-autocomplete"/> <TD class="-pantsName-gov -pantsType-tags"/> <TD class="-pantsType-commands"/> </TR> <TR> <TD class="-pantsName-event -pantsType-dropdown"/> <TD class="-pantsName-textn -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-textf -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="keywords -pantsType-text"> <P class="contenteditable" contenteditable="true">...</P> </TD> <TD class="-pantsName-speaker -pantsType-autocomplete"/> <TD class="-pantsName-gov -pantsType-tags"/> <TD class="-pantsType-commands"/> </TR> </TABLE>';
    
    var initData;
   
    if (typeof meetingName != 'undefined') {
        $("#metadata").toggle();
        $("#saveAs").toggle();
        document.title= "AGENDA " + meetingName;
        $("#titlePlaceholder").text(meetingName);
        // fetch the xml data
        
        $.ajax({
					type: 'GET',
					url:'/exist/rest//db/tullio/' + meetingName + '/agenda.xml',
					  dataType: "xml",
					success: function(xml, textStatus, XMLHttpRequest){
							initData = xml.getElementsByTagName("TABLE")[0];
                //console.log(initData);
            var s = new XMLSerializer();

var str = s.serializeToString(initData);
            $('#agenda').html(str);
            $('#agenda table').find("TD").each(function (index) {
        initializeCell(this);
    });
           
            $("#agenda table").addClass('footable');
            $("#agenda table").attr('id', 'sortable');		
			
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						
						alert('agenda file could not be loaded ' + unescape(errorThrown));
					},
					async: false
			});
        /*
        $.ajax({
        type: "POST",
        url: "/echo/xml/",
            async: false,
        dataType: "xml",
        data: {
            xml: tabledata
        },
        success: function(xml) {
            initData = xml;
                //console.log(initData);
            var s = new XMLSerializer();

var str = s.serializeToString(initData);
            $('#agenda').html(str);
            $('#agenda table').find("TD").each(function (index) {
        initializeCell(this);
    });
           
            $("#agenda table").addClass('footable');
            $("#agenda table").attr('id', 'sortable');

            
        }
    });*/
        
        
        
       
        
        
        
        
        
    }
    else {
    for (var i = 1; i <= 5; i++) {
  $("#saveAs").toggle();
    $("#save").toggle();
    addRow();
    

}
    
    }
    
    
    
// create 5 rows
    /*

*/
$(".button").button();
$("#datepicker").val('');
$("#sortable tbody").sortable({
    cancel: ':input,button,.contenteditable'
});



});

function addRow() {
    var newRow = $('<tr><td class="-pantsName-event -pantsType-dropdown"></td><td class="-pantsName-lang -pantsType-dropdown"></td> <td class="-pantsName-textn -pantsType-text"></td><td class="-pantsName-textf -pantsType-text"></td><td class="-pantsName-keywords -pantsType-text"></td><td class="-pantsName-speaker -pantsType-autocomplete"></td><td class="-pantsName-gov -pantsType-tags"></td><td class="-pantsType-commands"></tr>');

    newRow.children("td").each(function (index) {
        initializeCell(this);
    });

    $("#sortable").append(newRow);


}






  
    
    
function storeDoc(result,xsl,xml,obj) {
	
	
  
        
  // First check the current channel
  
  $.ajax({
  		url: "/exist/rest/db/tullio/" + meetingName + "/agenda.xml?_query=//channel&_howmany=1",
  		type: "GET",
  		contentType: "application/xml;charset=UTF-8",
  		async: false,
  		error: function (jqXHR, textStatus, errorThrown) {alert( "Save action failed." + textStatus );},
  		success: function (response) {
  			console.log("channel lookup");
  			var channelElement = response.getElementsByTagName("channel")[0];
  			if (typeof channelElement != 'undefined') {
  				result.getElementsByTagName("info")[0].appendChild(channelElement);
  			}
  			console.log(result);
  		}  
  });
  console.log("continue save");
  var serializer = new XMLSerializer ();
  var str = serializer.serializeToString (result);
 	console.log(result + " " + saveActions);
       
       
        
	$.ajax({
			url: "/exist/rest/db/tullio/" + meetingName + "/agenda.xml",
			type: "PUT",
			contentType: "application/xml;charset=UTF-8",
			username: 'admin',
			password: 'paris305',
			data: str,
			async: false,
			success: function(response) {
				saveActions = saveActions + 1;
				//alert("Stored as " + meetingName);
				$("#titlePlaceholder").text(meetingName);
				 $( "#titlePlaceholder" ).animate({
backgroundColor: "#aa0000",
color: "#fff",
width: 500
}, 1000 );
				  $( "#titlePlaceholder" ).animate({
backgroundColor: "#fff",
color: "#000",
width: 240
}, 1000 );
					if (saveActions > 0) {
						$("#save").toggle(true);
						
					};
			
			},
			error: function (jqXHR, textStatus, errorThrown) {alert( "Save action failed." + textStatus );}
	});
}
function onError(html,xsl,xml,obj,ex) {
	alert("Error: " + ex.message);
}

// store tags data





function persistTags() {
var result = { tags : {tag : this.tokenInput("get")}};
var tags = x2js.json2xml_str(result);
var cell = $(this).parent("td");
cell.children("tags").remove();
cell.append(tags);
cell.attr('data-pants', JSON.stringify(this.tokenInput('get')));
	
	
// console.log(this.tokenInput("get"));
//console.log(x2js.json2xml_str(data));

	/*
		console.log(x2js.json2xml_str(laVa));
    console.log(x2js.json2xml_str(laVa));
    console.log(dataIsland);
    dataIsland = dataIsland.replace(/<([0-9]+)>/g, '<item n="$1">');
    dataIsland = dataIsland.replace(/<\/([0-9]+)>/g, '</item>');

    $(this).parent('td').attr('data-pants', JSON.stringify(kv));
    console.log("test: " + dataIsland);
    $(this).parent('td').append("<data>" + dataIsland + "</data>");

    console.log($(this).parent('td').parent('tr').find('input'));
    var gggg = x2js.json2xml_str($(this).parent('td').parent('tr').find('input.iii').tokenInput("get"));
    alert(gggg);
    console.log(JsonML.toXMLText(JsonML.fromHTML(document.getElementById('agenda'))));	
	*/
	
	
}


// text data does not have to be stored but is taken from the dom








function initializeCell(cell) {

    var name = "";
    var type = "";

    if ($(cell).attr('class')) {
        var nameMatch = $(cell).attr('class').match(nameTest);
        var typeMatch = $(cell).attr('class').match(typeTest);
    }
    //console.log(index + "r: " + nameMatch + typeMatch);

    if (nameMatch) name = nameMatch[1];
    if (typeMatch) type = typeMatch[1];
    // console.log(index + ": " + name + type);
    switch (type) {
        case 'dropdown':
            console.log("convert to dd");
            // there should be an entry in the config hash that points to an array with options    
            var s = $("<select id=\"selectId\" name=\"selectName\" />");
            var options = config[name];
            for (var i = 0; i < options.length; i++) {
            	    
            	 var settings = {};
            	 if (options[i] instanceof Array) {
            	 	 settings['value'] = options[i][1];
            	 	settings['text'] = options[i][0];
                		}
                		else {
                		 settings['value'] = options[i];
            	 	settings['text'] = options[i];
                		}
            	    
                $("<option />", settings).appendTo(s);


            }
            $(cell).append(s);
            if ($(cell).attr('data-pants')  ) {
                $(cell).children("select").val($(cell).attr('data-pants'));
                
                }


            break;

        case 'tags':
            console.log("initialize tags");

            var localData = config[name];
             var persistedData;
            var stored =  $(cell).attr('data-pants');
            
            if (stored != undefined && stored != "") {
                console.log(stored);
                persistedData = JSON.parse(stored);
            }
            
            $(cell).append("<input class='iii' type='text' ></input>").children("input").tokenInput(localData, {
                theme: 'facebook',
                prePopulate:persistedData,
                onAdd: persistTags,
                onDelete: persistTags
                
            });
          
            break;

        
            
        case 'text':
            if ($(cell).children("p").length == 0) {
            		if ( $(cell).text() == "" || ($(cell).text().match(/^\s+$/) != undefined)  ) {
            			$(cell).empty();
            			$(cell).append("<p class='editableText'>...</p>");
            		}
            		else {
            			var oldC = $(cell).text();
            			$(cell).empty();
            			$(cell).append("<p class='editableText'>" + oldC + "</p>");
            		}
            		$(".editableText").editable(
            		  function(value, settings) {return (value.replace(/\s/g, ' '));},
            		  {
            		      type: 'textarea',
            		      submit: 'OK'
            		  }
            		);
            		
            		
             }   
            break;
          
          
          
        case 'autocomplete':
        	var oldValue  = $(cell).text();
        	$(cell).empty();
        	
        	// .wrap("<input class='autocomplete' type='text'></input>");
          var i = $("<input class='autocomplete' type='text'></input>");
          i.autocomplete({
        	 		 source: function(req, response) {
        	 		 	 var re = $.ui.autocomplete.escapeRegex(req.term);
        	 		 	 var matcher = new RegExp( "^" + re, "i" );
        	 		 	  response($.grep( members, function(item){ 
        	 		 	  	return matcher.test(item.label); }) ); 
        	 		 	}
        	 		 }); 
            
           i.val(oldValue); 
        	$(cell).append(i);
            /*
        	$(cell).children("input").autocomplete({
        	 		 source: function(req, response) {
        	 		 	 var re = $.ui.autocomplete.escapeRegex(req.term);
        	 		 	 var matcher = new RegExp( "^" + re, "i" );
        	 		 	  response($.grep( members, function(item){ 
        	 		 	  	return matcher.test(item.label); }) ); 
        	 		 	}
        	 		 });
        	  // i.val($(cell).attr("data-pants"));*/
        	break;

        case 'commands':
            $(cell).append("<button class='delete'>Delete</button>");
            $(cell).children().button({ text: false, icons: { primary: "ui-icon-closethick" } })
        default:

    }





}


