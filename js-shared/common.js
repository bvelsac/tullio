// Loads configured speakers, event types, status codes
// Need to declare variable 'target' before this script is loaded

// also adds two general purpose functions
//************** CONFIGURATION *******
	


	var eventTypes = {};
	var speakers = [];
	var government = [];
	var allSpeakers = [];
	var languages;
	var statusCodes = {};
	
	var langMap = {};
	
	
	languages = {N: 	[ [ 'Nederlands' ,  'N' ], [ 'Frans' ,  'F' ] ],
	F: [ [ 'néerlandais' ,  'N' ], [ 'français' ,  'F' ] ]};
	
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

function jq(myid) {
   return '#' + myid.replace(/(:|\.)/g,'\\$1');
 }
	
	// load config data from server
	// script could limit the data depending on the meeting, add headers to optimize caching
	var requestConfig = "/exist/tullio/xml/titles.xml";
	
	// function fills the speakers and government arrays
	function setSpeakers(response) {
		var people = response.getElementsByTagName("person");
    var nP = people.length;
		var pLang;
		var j =0;
		var k =0;
		var p =0;
		console.log("¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨p" + nP);
		 for (i=0; i<nP; i++) {
			 if (people[i].getAttribute('id')) {
				allSpeakers[p] = [ people[i].getElementsByTagName('last')[0].firstChild.nodeValue + ', ' + people[i].getElementsByTagName('first')[0].firstChild.nodeValue + ' (' + people[i].getAttribute('group') + ')', people[i].getAttribute('id')];
				p++;	 
			 }
			 if (people[i].getAttribute('id') && people[i].getAttribute('gov')=='no') {
				 // console.log(people[i].getAttribute('id'));
				 // console.log(people[i].getElementsByTagName('first')[0].firstChild.nodeValue);
				 speakers[j] = [ people[i].getElementsByTagName('last')[0].firstChild.nodeValue + ', ' + people[i].getElementsByTagName('first')[0].firstChild.nodeValue + ' (' + people[i].getAttribute('group') + ')', people[i].getAttribute('id')];
				 j++;
			}
			if (people[i].getAttribute('id') && people[i].getAttribute('gov')=='yes') {
				 console.log('+++' + people[i].getAttribute('id'));
				 // console.log(people[i].getElementsByTagName('first')[0].firstChild.nodeValue);
				 government[k] = [ people[i].getElementsByTagName('last')[0].firstChild.nodeValue + ', ' + people[i].getElementsByTagName('first')[0].firstChild.nodeValue + ' (' + people[i].getAttribute('group') + ')', people[i].getAttribute('id')];
				 k++;
			}
			
			pLang = people[i].getAttribute('lang');
			langMap[people[i].getAttribute('id')] = (pLang == 'nl') ? 'N' : 'F'; 
		}
		
		
	}
	
	jQuery.ajax({
			 	type: "GET",
        url:    requestConfig,
        success: setSpeakers,
				dataType: "xml",
				async: false
	 });
	
	var requestConfig = "/exist/tullio/xq/return-eventTypes.xql?target=" + target;
	
	function setEventTypes(response) {
		var nlList = [];
		var frList = [];
		
		var counter = 0;
		$(response).find('event').each(function(){
				var id = $(this).attr('id');
				var labelN = $(this).find("name[lang='nl']").text();
				var labelF = $(this).find("name[lang='fr']").text();
				nlList[counter] = [labelN, id];
				frList[counter] = [labelF, id];
				counter++;
		});
		// console.log(nlList);
		eventTypes.N = nlList;
		eventTypes.F = frList;
		console.log(eventTypes);
	}
	
	jQuery.ajax({
			 	type: "GET",
        url:    requestConfig,
        success: setEventTypes,
				dataType: "xml",
				async: false 
	 });
	
	var requestConfig = "/exist/tullio/xml/statusCodes.xml";
	
		function setStatusCodes(response) {
		var nlList = [];
		var frList = [];
		
		var counter = 0;
		$(response).find('code').each(function(){
				var id = $(this).attr('id');
				var labelN = $(this).find("label[lang='nl']").text();
				var labelF = $(this).find("label[lang='fr']").text();
				nlList[counter] = [labelN, id];
				frList[counter] = [labelF, id];
				counter++;
		});
		// console.log(nlList);
		statusCodes.N = nlList;
		statusCodes.F = frList;
		console.log(statusCodes);
	}

	
	jQuery.ajax({
			 	type: "GET",
        url:    requestConfig,
        success: setStatusCodes,
				dataType: "xml",
				async: false 
	 });
	
