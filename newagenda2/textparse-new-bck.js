/*

Load titles XML (again)

*/

var titleDocElement;
var titleDoc;
var xotree = new XML.ObjTree();

jQuery.ajax({
    url: "/exist/tullio/xml/titles.xml",
    success: function (result) {
    	titleDoc = result;
      titleDocElement = result.documentElement;
    },
    async: false,
    contentType: "text/xml"
});

var personDictionary = {};
var MPs = [];
var tp_gov = [];

var personsSnapshot = titleDoc.evaluate('//person', titleDocElement, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null );
 
for ( var i=0 ; i < personsSnapshot.snapshotLength; i++ )
{
	var fname = titleDoc.evaluate('first', personsSnapshot.snapshotItem(i), null, XPathResult.STRING_TYPE, null ).stringValue;
	var lname = titleDoc.evaluate('last', personsSnapshot.snapshotItem(i), null, XPathResult.STRING_TYPE, null ).stringValue;
	var personId = titleDoc.evaluate('@id', personsSnapshot.snapshotItem(i), null, XPathResult.STRING_TYPE, null ).stringValue;
	var govStatus = titleDoc.evaluate('@gov', personsSnapshot.snapshotItem(i), null, XPathResult.STRING_TYPE, null ).stringValue;
	console.log('>> ' + lname + fname + personId);

	personDictionary[lname.toUpperCase()] = personId;
	if (govStatus == 'yes') {
		tp_gov.push(lname.toUpperCase());
	}
	else { 	MPs.push(lname.toUpperCase()); }
}
console.log(tp_gov);
console.log(MPs);
console.log(personDictionary);

var starts = {};
var typeDictionary = {};
var types = [];
var entries = {};

starts['N'] = ["Toegevoegde interpellatie ", "Interpellatie ", "Toegevoegde mondelinge vraag ", "Mondelinge vraag ", "Toegevoegde dringende vraag ", "Dringende vraag " ];

starts['F'] = ["Interpellation jointe ", "Interpellation ", "Question orale jointe ", "Question orale ", "Question d'actualité jointe ", "Dringende vraag " ];
 
typeList = ["INT JOINTE", "INT", "QO-MV JOINTE", "QO-MV", "QA-DV JOINTE", "QA-DV"];

starts['N'].forEach(
		function(v, i) {
			typeDictionary[v]=i;
		});

starts['F'].forEach(
		function(v, i) {
			typeDictionary[v]=i;
		});

var types = S(_.reduce(starts['N'], function (memo, num) {
    return memo + num + "|";
}, "")).chompRight('|').s;
entries['N'] = new RegExp(types, 'gi');
types = S(_.reduce(starts['F'], function (memo, num) {
    return memo + num + "|";
}, "")).chompRight('|').s;
entries['F'] = new RegExp(types, 'gi');

var reMembers = S(_.reduce(MPs, function (memo, num) {
    return memo + num.toUpperCase() + "|";
}, "")).chompRight('|').s;
var creMembers = new RegExp(reMembers, 'i');

var reGov = S(_.reduce(tp_gov, function (memo, num) {
    return memo + num.toUpperCase() + "|";
}, "")).chompRight('|').s;
var creGov = new RegExp(reGov, 'gi');

console.log(entries);
console.log(creMembers);
console.log(creGov);
console.log(typeDictionary);
console.log(types);

var type;
var agendaArray1 = [];
var agendaArray2 = [];






function analyseChunk(text, lang, type, targetArray) {
    console.log("1");
    console.log(text);
    var tempArray = [];
    var msg = [];
    tempArray.push(typeList[typeDictionary[type]]);
    var itemLang = S(text).between('(', ')').s;
    tempArray.push(itemLang);
    // test on MPs
    console.log(creMembers);
    var resultArray = creMembers.exec(text.toUpperCase());
    // console.log("mp: " + resultArray);
    var speaker = (resultArray !== null) ? resultArray[0] : "";
    tempArray.push(personDictionary[speaker]);
    // console.log(speaker);
    // test on members of tp_government
    resultArray = null;
    while ((resultArray = creGov.exec(text)) !== null) {
    	msg.push(personDictionary[resultArray[0]]);
    }
    tempArray.push(msg);
    //console.log(text.indexOf("«"));
    // extract the subject
    var subject = S(text).between('«', '»').s;
    
    var subject2 = S(text).between('“', '”').s;
    //console.log("subject" + subject + subject2);
    subject = (typeof subject === 'undefined' || subject == null || subject == "") ? subject2 : subject;
    tempArray.push(subject);
    
    targetArray.push(tempArray);
    console.log(tempArray);
    
}

function parseInput(lines, lang, targetArray) {

    var resultArray;
    var chunk = "";
    var mem = "";
    while ((resultArray = entries[lang].exec(lines)) !== null) {
        var msg = "Found " + resultArray[0] + ". ";

        if (mem != "") {
            chunk = lines.substring(mem, resultArray.index - 1);
            analyseChunk(chunk, lang, type, targetArray);
        }
        type = resultArray[0];
        mem = resultArray.index;




    }
    // analyse last chunk

    analyseChunk(lines.substring(mem), lang, type, targetArray);


}






function launchConversion() {
	console.log("button clicked");
	parseInput($("#inputFR").val().replace(/\s+/g, ' '), 'F', agendaArray1);
	parseInput($("#inputNL").val().replace(/\s+/g, ' '), 'N', agendaArray2);
	var newRows = $(dataToHTML(agendaArray1, agendaArray2));
	newRows.find("td").each(function (index) {
        initializeCell(this);
  });
  $( "#dialog" ).dialog( "close" );
	$("#sortable").append(newRows);
	

	/*
	
	 console.log(JSON.stringify(agendaArray1));
   console.log(JSON.stringify(agendaArray2));
   
  
     
   xmlDump = xotree.writeXML(agendaArray1);
   console.log(xmlDump);
   console.log(xotree.writeXML(agendaArray2));
   
   // append the new rows to the table
   */
   
   
}



function dataToHTML(agendaArray1, agendaArray2) {
	var htmlCode = "";
	
	/*
	[["INT","F","DE BOCK_Emmanuel",["FREMAULT_Céline"],"de oorzaken van de werkloosheid in Brussel"]] 
	*/
	// eerste cijfer : positie in de array met info, tweede cijfer  is welke array er moet worden gebruikt
	var spec = [['event', 'dropdown', 1, 0],
	['lang', 'dropdown', 2, 0],
	['textn', 'text', 5, 1], 
	['textf', 'text', 5, 0], 
	['keywords', 'text', 0, 0], 
	['speaker', 'autocomplete', 3, 0],
	['gov', 'tags', 4, 0]];
	
	modelLength = spec.length;
	
	// loop through array 1
	nrOfRecords = agendaArray1.length;
	 for (c=0; c<nrOfRecords; c++) {
	 	 htmlCode = htmlCode + "<TR>";
	 	 
			for (i=0; i<modelLength; i++) {
				htmlCode = htmlCode + "<TD";
				htmlCode = htmlCode + " class='-pantsName-" + spec[i][0];
				
				htmlCode = htmlCode + " -pantsType-" + spec[i][1];
				htmlCode = htmlCode + "'";
				if (spec[i][1] == 'dropdown' ) {
						htmlCode = htmlCode + " data-pants='" + agendaArray1[c][spec[i][2]-1] +"'>";
				}
				if (spec[i][1] == 'tags' ) {
					htmlCode = htmlCode + " data-pants='";
					htmlCode = htmlCode + '[{&#34;id&#34;:&#34;' + agendaArray1[c][spec[i][2]-1] + '&#34;,&#34;name&#34;:&#34;' + agendaArray1[c][spec[i][2]-1] +'&#34;}]';
					htmlCode = htmlCode + "'>";
				}
				if (spec[i][1] == 'autocomplete' || spec[i][1] == 'text' ) {
                    htmlCode = htmlCode + ">";
                    if (spec[i][0]=="keywords"){
                        var generatedKeywords = "";
                        var kwCounter = 0;
                        var lang = agendaArray2[c][2];
                        var base;

                        if (lang == "N") base = agendaArray2[c][4];
                        else base = agendaArray1[c][4];

                        var mySplitResult = base.split(/\s+/);

                        for(var d = 0; d < mySplitResult.length; d++){
                            if (mySplitResult[d].length > 3 && kwCounter < 4 ) {
                                generatedKeywords = generatedKeywords + mySplitResult[d] + " ";
                                kwCounter++;
                            }
                        }
                        htmlCode = htmlCode + generatedKeywords;
                    }
					else if (spec[i][3] == 1) {
						htmlCode = htmlCode + agendaArray2[c][spec[i][2]-1];
						
					}
                    else {
                        htmlCode = htmlCode + agendaArray1[c][spec[i][2]-1];
                    }



					
				}
				
				
				
				
				
				
				htmlCode = htmlCode + "</TD>";
			}
	 	 htmlCode = htmlCode + " <TD class='-pantsType-commands'/></TR>";
	 }

console.log(htmlCode);
return htmlCode;

}



var agendaArray1 = [];
var agendaArray2 = [];






