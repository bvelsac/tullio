
// Utility Functions
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

function jq(myid) {
  return '#' + myid.replace(/(:|\.)/g, '\\$1');
}

function sanitize(myid) {
  return myid.replace(/(:|\.)/g, '\\$1');
}
// Global Variables	
var startEditor;
var clickmemory;
var dbUrl = "/exist/rest//db/tullio/";
var newe;
var noUpdate = false;
var updateCounter = 0;
var scrollState = 0;
var start = "";
var stop = "";
var visibleRows = [];
var visibles = "";
var meeting = "";
var ids = "";
var edited = "";
var editor;
var rowId;
var bottom;
var channel;
var langChoice;
var rowToUpdate;
var updated = 0;
var preEdit;
var titles = null;
var titlesDoc;
var events = null;
var eventsDoc;
var interval;
var previousUpdate;
var runTrans = $.QueryString["t"];
var mt = "";
// Set Variables, Check Session
//****** check session ********
var stringifier = new XMLSerializer();
var snap;
var user;
var msgStore = {
  "xclip": {
    "N": "Wil je een bijkomende clip vergrendelen ?",
    "F": "Voulez-vous vérouiller un clip additionnel ?"
  }
};
console.log(msgStore);

function setMeetingType(meeting) {
  var fullQuery = '/exist/rest/db/tullio/' + meeting + '?_query=' + 'document("agenda.xml")//info';
  $.ajax({
    url: fullQuery,
    dataType: 'xml',
    async: false,
    success: function (data) {
      // console.log (data);
      // console.log ($(data).find('success'));
      if ($(data).find('name')[0] != null) {
        mt = $(data).find("name").text();
        // console.log(mt);
        // data mapping
        var mTypes = {
          'PLEN': 'VAR',
          'COM-AEZ': 'BHP',
          'COM-AIBZ': 'BHP',
          'COM-ATRO': 'BHP',
          'COM-ENVMIL': 'BHP',
          'COM-FIN': 'BHP',
          'COM-INFRA': 'BHP',
          'COM-LOGHUIS': 'BHP',
          'COM-SANGEZ': 'VVGGC',
          'COM-ASSZ': 'VVGGC',
          'COM_ASSZSANGEZ': 'VVGGC',
          'PFB': 'PFB'
        };
        mt = mTypes[mt];
        console.log(mt);
      }
      if ($(data).find('channel')[0] != null) {
        channel = $(data).find("channel").text();
      }
      console.log('channel,' + channel);
      return true;
    }
  });
}
//************** CONFIGURATION *******
var eventTypes = {};
var speakers = [];
var government = [];
var languages;
var statusCodes = {};
var team;
// define simple configuration for use in CKEditor plugin
languages = {
  N: [
    ['Nederlands', 'N'],
    ['Frans', 'F']
  ],
  F: [
    ['néerlandais', 'N'],
    ['français', 'F']
  ]
};
// load config data from server
// script could limit the data depending on the meeting, add headers to optimize caching
var requestConfig = "/exist/tullio/xml/titles.xml";
// function fills the speakers and government arrays
function setSpeakers(response) {
  var people = response.getElementsByTagName("person");
  var nP = people.length;
  var j = 0;
  var k = 0;
  // console.log ("¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨p" + nP);
  for (i = 0; i < nP; i++) {
    if (people[i].getAttribute('id') && people[i].getAttribute('gov') == 'no') {
      // // console.log (people[i].getAttribute('id'));
      // // console.log (people[i].getElementsByTagName('first')[0].firstChild.nodeValue);
      speakers[j] = [people[i].getElementsByTagName('last')[0].firstChild.nodeValue + ', ' + people[i].getElementsByTagName('first')[0].firstChild.nodeValue + ' (' + people[i].getAttribute('group') + ')', people[i].getAttribute('id')];
      j++;
    }
    if (people[i].getAttribute('id') && people[i].getAttribute('gov') == 'yes') {
      // console.log ('+++' + people[i].getAttribute('id'));
      // // console.log (people[i].getElementsByTagName('first')[0].firstChild.nodeValue);
      government[k] = [people[i].getElementsByTagName('last')[0].firstChild.nodeValue + ', ' + people[i].getElementsByTagName('first')[0].firstChild.nodeValue + ' (' + people[i].getAttribute('group') + ')', people[i].getAttribute('id')];
      k++;
    }
  }
  // console.log (government);
}
jQuery.ajax({
  type: "GET",
  url: requestConfig,
  success: setSpeakers,
  dataType: "xml"
});
requestConfig = "/exist/tullio/xq/return-eventTypes.xql?target=editor";

function setEventTypes(response) {
  // eventsDoc = response;
  events = response.documentElement;
  var nlList = [];
  var frList = [];
  var counter = 0;
  $(response).find('event').each(function () {
    var id = $(this).attr('id');
    var labelN = $(this).find("name[lang='nl']").text();
    var labelF = $(this).find("name[lang='fr']").text();
    nlList[counter] = [labelN, id];
    frList[counter] = [labelF, id];
    counter++;
  });
  // // console.log (nlList);
  eventTypes.N = nlList;
  eventTypes.F = frList;
  // console.log (eventTypes);
}
jQuery.ajax({
  type: "GET",
  url: requestConfig,
  success: setEventTypes,
  dataType: "xml"
});
requestConfig = "/exist/tullio/xml/statusCodes.xml";

function setStatusCodes(response) {
  var nlList = [];
  var frList = [];
  var counter = 0;
  $(response).find('code').each(function () {
    var id = $(this).attr('id');
    var labelN = $(this).find("label[lang='nl']").text();
    var labelF = $(this).find("label[lang='fr']").text();
    nlList[counter] = [labelN, id];
    frList[counter] = [labelF, id];
    counter++;
  });
  // // console.log (nlList);
  statusCodes.N = nlList;
  statusCodes.F = frList;
  // console.log (statusCodes);
}
jQuery.ajax({
  type: "GET",
  url: requestConfig,
  success: setStatusCodes,
  dataType: "xml"
});
/* Utility function : get query parameters */
var mmm = $.QueryString["m"];
var meetingDate = mmm.substr(0, 10);
setMeetingType(mmm);
/* load user data */
var user;
var userLang;
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
/*

CORE FUNCTIONALITY

*/
var requestLocks = "/exist/tullio/xq/return-locks.xql?m=" + mmm;

function handleStatusUpdate(statusData, xsinit) {
  // update all elements that show status information
  // console.log("000003 handlestatusupdate" + new Date().getTime());
  var statusTD;
  var cell;
  $("td.status").removeClass('locked');
  $(".lockid > p").text(' ');
  $("#prepare  div").removeClass('locked');
  $("#prepare .lockid").text(' ');
  var items = statusData.getElementsByTagName("lock");
  var nI = items.length;
  
  /*
  Next loop updates locking info 
  */
  for (var i = 0; i < nI; i++) {
    if (items[i].getAttribute('n')) {
      
      // First the main table
      
      statusTD = "status-" + items[i].getAttribute('n') + "-" + items[i].getAttribute('v');
      if ($(jq(statusTD)).length > 0) {
        cell = $(jq(statusTD));
        // console.log(cell.find("div.lockid > p"));
        cell.find("div.lockid > p").text(items[i].getAttribute('id'));
        cell.addClass('locked');
      
					
				}
				 else {
					console.debug("not found " + statusTD); 
				 }
      
      // Then the clip overview
      
      // path looks like: .clipstatus-orig div.n125 span.user
      statusTD = ".clipstatus-" + items[i].getAttribute('v') + " .n" + sanitize(items[i].getAttribute('n'));

				 if ($(statusTD).length > 0) {
					 console.log("cell found");
					 cell = $(statusTD);
					 cell.addClass('locked');
					 cell.find("span.lockid").text(items[i].getAttribute('id'));
					
				 }
				 else {
					console.debug("not found " + statusTD); 
					 
				 }

    }
  }
  
  /*
  Next loop updates status info
  */
  
  // now loop over the rows to add the status code
  items = statusData.getElementsByTagName("s");
  $("span.status-code").text(' ');
  nI = items.length;
  for (i = 0; i < nI; i++) {
    if (items[i].getAttribute('n')) {
      var col = '';
      // get the cell with the status codes
      statusTD = "status-" + items[i].getAttribute('n') + "-" + items[i].getAttribute('v');
      if (items[i].getAttribute('v') == "trans") {
        col = 'T'
      }
      if (col != "T" || (col == "T" && runTrans == "yes")) {
        
        // Test if the cell has been found -- this is often not the case because ***the main table doesn't contain all clips***.
         if ($(jq(statusTD)).length > 0) {
           
         cell = $(jq(statusTD));
        // get the language code as displayed in the cell
        var lang = $('#status-' + items[i].getAttribute('n') + '-' + items[i].getAttribute('v') + '-lang').text();
        // set the text content of the span that contains the status code
        // create the id
        var tempId = 'status-' + items[i].getAttribute('n') + '-' + items[i].getAttribute('v') + '-code';
        // check the code
        var tempCode = items[i].getAttribute('val') + col;
        // delete existing status codes
        if (cell.attr('class').indexOf('status-') != -1) {
          // console.log(cell.attr('class'));
          cell.removeClass(function (i, c) {
            return c.match(/status\-.?.?/g).join(" ");
          });
        }
        // set the class of the status cell
        cell.addClass('status-' + items[i].getAttribute('val') + col);
        cell.find('span.status-code').text(tempCode);
        // console.log(cell);
        // also update class of hidden cells !
        // console.log('#hidden td[id="' + sanitize(statusTD) + '"]');
        cell = $('td[id="' + sanitize(statusTD) + '"]');
        // console.log(cell);
        cell.addClass('status-' + items[i].getAttribute('val') + col);
         
         
         
         }
         else {
           console.debug("not found " + statusTD); 
         }
        
        
      }
      // alert(cell);
      // add locking info to the frames in the clip overview
      // path looks like: .clipstatus-orig div.n125.stat-T span.code
      statusTD = ".clipstatus-" + items[i].getAttribute('v') + " .n" + sanitize(items[i].getAttribute('n'));
      if ($(statusTD).length > 0) {
      cell = $(statusTD);
        
      cell.removeClass(function (i, c) {
        return c.match(/stat\-..?/g).join(" ");
      });
      cell.addClass('stat-' + items[i].getAttribute('val'));
      cell.find("span.code").text(items[i].getAttribute('val'));
    }
    else {
    console.debug("cell not found " + statusTD);
    }
    }
  }
  if (xsinit) {
    var newframes = $("#prepare").children().clone();
    newframes.attr('id', 'temp');
    $("#clipframes").replaceWith(newframes);
    $("#temp").attr('id', 'clipframes');
   
  }
}

function initiateStatusUpdate(xsinit) {
  // if (init) {alert('init update');}
  // console.log("000002 initiatestatusupdate" + new Date().getTime());
  // the request retrieves *all* currently active locks and status codes
  jQuery.ajax({
    type: "GET",
    url: requestLocks,
    success: function (data) {
      $(".ui-layout-north").removeClass('networkDown');
      $(".ui-layout-north").addClass('networkOK');
      $("#network").text("Network OK");
      handleStatusUpdate(data, xsinit);
    },
    dataType: "xml",
    error: function (request, status) {
      $(".ui-layout-north").removeClass('networkOK');
      $(".ui-layout-north").addClass('networkDown');
      $("#network").text("Network " + status);
    }
  });
}

function clipFramesHandler(frames, xsl, xml, transform) {
  initiateStatusUpdate(true);
}

function displayStatus() {
  var init;
  interval = new Date().getTime() - updated;
  $("#interval").text('(' + interval + ')');
  init = (interval > 5000) ? true : false;
  if (true) {
    // fetch the up to date clip listing and then run the status update as usual
    // get xml data and generate the new listing framework as a hidden element
    clipRequest = "/exist/rest//db/tullio/" + mmm + "/events.xml?_query=//e[@c='true']&_howmany=10000";
    $("#prepare").transform({
      async: true,
      success: clipFramesHandler,
      xml: clipRequest,
      xsl: "xsl/createClipListing.xsl"
    });
  } else {
    // otherwise just run the status update directly
    // console.log('re-use existing frames');	
    initiateStatusUpdate();
  }
}

function loopDisplayStatus() {
  displayStatus();
  setTimeout(loopDisplayStatus, 4000);
}

function docupdate() {
  // replace
  var rows = $("#hidden > tr");
  var origrowIds = ids.split(',');
  $("#hidden td.status").removeClass('status-');
  // displayStatus must be run first to set the correct status code on the newly generated rows / cells (to be checked)
  displayStatus();
  for (var i = 0; i < rows.length; i++) {
    // console.log ("0replace: " + origrowIds[i] + ":" + visibleRows[i] + ":" +edited);
    // do not replace the currently edited row
    if (visibleRows[i] != edited.slice(0, -2)) {
      // alert("about to replace, it. " + updateCounter + "." + i)
      // keep editor in place								
      if (origrowIds[i] == undefined && bottom != "") {
        // console.log ("!!! found extra rows");
        // table is scrolled to the bottom so the server returned all clips to the end and we have extra rows
        // next line adds these rows to the result table
        $("#result > tr").filter(":last").after($("#hidden > tr"));
        // console.log ("!!! replaced extra rows");
        bottom = "";
        break;
      } else {
        // console.log('^^^^   before');
        // console.log($("#hidden > tr:eq(0)").html());
        // replace cell "Play" 
        $("#result > tr" + origrowIds[i] + " > td:eq(0)").replaceWith($("#hidden > tr:eq(0) > td:eq(0)"));
        // replace cell "Events"
        $("#result > tr" + origrowIds[i] + " > td:eq(1)").replaceWith($("#hidden > tr:eq(0) > td:eq(0)"));
        // replace original text
        $("#result > tr" + origrowIds[i] + " > td:eq(3)").replaceWith($("#hidden > tr:eq(0) > td:eq(1)"));
        if (runTrans == 'yes') {
          // replace translation
          $("#result > tr" + origrowIds[i] + " > td:eq(5)").replaceWith($("#hidden > tr:eq(0) > td:eq(2)"));
        }
        // console.log('^^^^   after');
        // console.log($("#hidden > tr:eq(0)").html());
        $("#hidden > tr:eq(0)").remove();
      }
      // alert("done");
    } else {
      $("#hidden > tr:eq(0)").remove();
    }
  }
  if (edited) {
    newPosition = $(jq(edited)).offset().top;
  }
  if (newe && edited) {
    console.log('********scrollback');
    // for FF use html root element to adjust scrollbar 
    $("html").scrollTop($("html").scrollTop() + newPosition - newe);
    // $("body").scrollTop($("body").scrollTop() + newPosition - newe);
    newe = $(jq(edited)).offset().top;
  }
  $("#" + edited.replace(/\./g, "\\.")).addClass('edited');
  var ckToolBarConfig = [{
    name: 'tullio',
    items: ['Print', '-', 'Find', 'Replace', '-', 'Styles', 'Undo', 'PasteText', 'Ajaxsave', 'internalSync', 'Remove', 'Abbr', 'Status', 'Source', 'Exit']
  }];
  if (startEditor) {
    startEditor = false;
    // console.log(jq(preEdit));
    // console.log( $(jq(preEdit)).html() );
    var cell = $(jq(preEdit));
    cell.children("div:first-child").attr('id', 'cke');
    rowId = cell.parent().attr('id');
    var cellHeight = (cell.height() > ($(window).height() - 235)) ? ($(window).height() - 235) : cell.height();
    var adjustedHeight = (cellHeight < 300) ? 300 : cellHeight;
    var cellWidth = cell.width();
    if (runTrans == "yes") {
      var fixedHeight = cell.parent().height();
      cell.parent().attr('style', 'height: ' + fixedHeight + "px");
      cell.prevAll(".orig").children("div.editable").attr('style', 'height: ' + (adjustedHeight + 50) + 'px; overflow-y: auto;');
    }
    snap = "";
    editor = CKEDITOR.replace('cke', {
      toolbar: ckToolBarConfig,
      extraPlugins: 'remove,internalSync,ajaxsave,transform,abbr-custom,status,exit',
      disableNativeSpellChecker: false,
      removePlugins: 'scayt,contextmenu',
      startupFocus: false,
      templates_files: ['ckeditor/plugins/templates/templates/default.js'],
      fillEmptyBlocks: false,
      entities_processNumerical: 'force',
      resize_enabled: true,
      resize_dir: 'vertical',
      height: adjustedHeight,
      width: cellWidth
    });
    snap = editor.getSnapshot();
    var isCtrl = false;
    editor.on('contentDom', function (evt) {
      editor.document.on('keyup', function (event) {
        if (event.data.$.keyCode == 17) isCtrl = false;
        if (event.data.$.keyCode == 16) isShift = false;
      });
      editor.document.on('keydown', function (event) {
        if (event.data.$.keyCode == 17) isCtrl = true;
        if (event.data.$.keyCode == 16) isShift = true;
        if ((event.data.$.keyCode == 68 && isCtrl == true && isShift == true)) {
          editor.execCommand('pastetext');
        }
        if ((event.data.$.keyCode == 68 && isCtrl == true) || event.data.$.keyCode == 120) { // TOGGLE = D
          //The preventDefault() call prevents the browser's save popup to appear.
          //The try statement fixes a weird IE error.
          try {
            event.data.$.preventDefault();
          } catch (err) {}
          lastSound = pagePlayer.lastSound.sID;
          if (lastSound != undefined) {
            // console.log (lastSound);
            soundManager.togglePause(lastSound);
            return false;
          }
        }
        if ((event.data.$.keyCode == 68 && isCtrl == true) || event.data.$.keyCode == 120) { // TOGGLE = D
          //The preventDefault() call prevents the browser's save popup to appear.
          //The try statement fixes a weird IE error.
          try {
            event.data.$.preventDefault();
          } catch (err) {}
          // console.log ('save key');
          //Call to your save function
          lastSound = pagePlayer.lastSound.sID;
          if (lastSound != undefined) {
            // console.log (lastSound);
            soundManager.togglePause(lastSound);
            return false;
          }
        }
        if ((event.data.$.keyCode == 83 && isCtrl == true)) {
          editor.execCommand('ajaxsave');
        }
        if (event.data.$.keyCode == 114) {
          // REWIND= S
          //The preventDefault() call prevents the browser's save popup to appear.
          //The try statement fixes a weird IE error.
          try {
            event.data.$.preventDefault();
          } catch (err) {}
          // console.log ('save key');
          //Call to your save function
          lastSound = pagePlayer.lastSound.sID;
          lastSound = pagePlayer.lastSound.sID;
          if (!lastSound) {
            // console.log ('no sound');
            return false;
          }
          var s = soundManager.getSoundById(lastSound);
          if (!s || !s.playState || !s.duration) {
            // console.log ("something wrong");
            return false;
          }
          // console.log (s.position);
          s.setPosition(s.position - 5000);
        }
        if ((event.data.$.keyCode == 70 && isCtrl == true) || event.data.$.keyCode == 115) {
          // REWIND= S
          //The preventDefault() call prevents the browser's save popup to appear.
          //The try statement fixes a weird IE error.
          try {
            event.data.$.preventDefault();
          } catch (err) {}
          // console.log ('save key');
          //Call to your save function
          lastSound = pagePlayer.lastSound.sID;
          lastSound = pagePlayer.lastSound.sID;
          if (!lastSound) {
            // console.log ('no sound');
            return false;
          }
          var s = soundManager.getSoundById(lastSound);
          if (!s || !s.playState || !s.duration) {
            // console.log ("something wrong");
            return false;
          }
          // console.log (s.position);
          s.setPosition(s.position + 5000);
        }
      });
    }, editor.element.$);
    edited = preEdit;
    preEdit = "";
  }
}

function secondstep(xml, xsl, xmlorig) {
  // console.log ("***** UPDATE ****");
  xml.getElementsByTagName("all")[0].appendChild(titles);
  xml.getElementsByTagName("all")[0].appendChild(events);
  // console.log (new XMLSerializer().serializeToString(xml));
  $("#hidden").transform({
    success: docupdate,
    async: true,
    xmlobj: xml,
    xsl: "xsl/group.xsl",
    xslParams: {
      mode: runTrans,
      channel: channel
    }
  });
}

function isVisible(id) {
  var cutoffTop = $(window).scrollTop();
  var cutoffBottom = $(window).scrollTop() + $(window).height();
  var currTop = $("#" + id).offset().top;
  var currBottom = $("#" + id).offset().top + $("#" + id).height();
  return currTop > cutoffTop || currBottom > cutoffTop || (currTop < cutoffTop && currBottom > cutoffBottom);
}

function updateVisibleTexts() {
  $('#title').attr('style', 'color: tomato');
  $('#title').animate({
    color: '#00cc99'
  }, 2000);
  // console.log('refresh');
  if (noUpdate) {
    // console.log('refresh killed');
    return true;
  }
  updated = new Date().getTime();
  $('#text-table tr').removeClass('ruby');
  if (true) {
    visibles = "";
    visibleRows.length = 0;
    var cutoffTop = $(window).scrollTop();
    var cutoffBottom = $(window).scrollTop() + $(window).height();
    var switchFirst = 0;
    var switchStop = 0;
    bottom = "";
    $('#text-table > tbody > tr').each(function () {
      var currTop = $(this).offset().top;
      var currBottom = $(this).offset().top + $(this).height();
      // // console.log (this.id + ': ' + cutoffTop + " " + cutoffBottom + " " + currTop + currBottom);
      if (currTop > cutoffTop || currBottom > cutoffTop || (currTop < cutoffTop && currBottom > cutoffBottom)) {
        console.log('row ' + this.id + ' is visible');
        visibleRows.push(this.id);
        visibles += "#" + this.id + ",";
        if (switchFirst == 0) {
          start = this.id;
          switchFirst = 1;
        }
        if ($(this).offset().top > cutoffBottom) {
          switchStop = "1";
          stop = this.id;
          return false; // stops the iteration after the first invisible row 
        }
      }
    });
    scrollState = 0;
    if (switchStop == 0) {
      // all rows are visible
      // take the id of the last row in the table as stop id
      stop = $('#text-table > tbody > tr:last').attr("id");
      bottom = "&bottom=yes";
      // console.log ("using last row id: " + stop);
    }
    updateCounter++;
    // console.log ("start: " + start + " stop: " + stop);
    //	// console.log (visibleRows);
    ids = "#" + visibleRows.toString().replace(/,/g, ',#');
    ids = ids.replace(/\./g, "\\.");
    // console.log ("visible rows: " + ids);
    // highlight refreshed rows
    $(ids).addClass('ruby');
    // create request
    stop = (stop == '') ? '' : stop.substring(1);
    var request = "../xq/return-combined.xql?mt=" + mt + "&m=" + mmm + "&start=" + start.substring(1) + "&stop=" + stop + "&include=" + runTrans + bottom;
    // console.log (request);
    // refresh the visible rows
    // query the DB for event and text data
    $.transform({
      async: true,
      dataType: "xml",
      success: secondstep,
      xml: request,
      xsl: "xsl/addclipref.xsl"
    });
  }
}

function loopRowUpdate() {
  updateVisibleTexts();
  setTimeout("loopRowUpdate()", 10000);
}

function initialize(xml, xsl, xmlorig) {
  console.log('************ init');
  console.log(xml);
  jQuery.get("/exist/tullio/xml/titles.xml",

  function (data, textStatus, jqXHR) {
    console.log(data);
    x = data.documentElement;
    xml.getElementsByTagName("all")[0].appendChild(titles);
    xml.getElementsByTagName("all")[0].appendChild(events);

    $("#result").transform({
      cache: false,
      async: false,
      dataType: "xml",
      xmlobj: xml,
      xsl: "xsl/group.xsl",
      xslParams: {
        mode: runTrans,
        channel: channel
      }
    });
    loopDisplayStatus();
    loopRowUpdate();
    console.log('initializion end');

  }, "xml");
  noUpdate = false;
}

function setupClipOverview(cells) {
  /**
		Generate cells to display the overview of clips. The overview starts up with a fixed number of clips. If the number of clips grow, additional rows will be added.
		@param {number} [cells=100] How many cells to create. Every cell represents one clip. Default value = 100 cells.
		*/
  var cellMarkup;
  cells = (cells === undefined || cells < 100) ? 100 : cells;
  for (var i = 0; i < cells; ++i) {
    cellMarkup = cellMarkup + "<div id=cs" + i + ">" + "<ul><li class='lang1'></li><li class='clip'></li> <li class='lang2'></li></ul></div>";
  }
	
  $("#clipstatus").append(cellMarkup);
}
$().ready(function () {
  if (runTrans == "yes") {
    $("body").addClass("trans");
  } else {
    $("body").addClass("orig");
  }
  $("#representation").text("Het scherm is te klein geworden om alles te kunnen tonen. Maakt u aub het venster groter, of verminder het zoomniveau (CTRL + -).");
  noUpdate = true;
  setUpPlayer();
  jQuery.ajax({
    url: "/exist/tullio/xml/titles.xml",
    success: function (result) {
      titles = result.documentElement;
      jQuery.ajax({
        type: "GET",
        url: "/exist/tullio/xq/return-eventTypes.xql?target=editor",
        success: function (response) {
          events = response.documentElement;
          $.transform({
            async: false,
            success: initialize,
            xml: "../xq/return-combined.xql?mt=" + mt + "&m=" + mmm + "&include=" + runTrans,
            xsl: "xsl/addclipref.xsl",
            xslParams: {
              translation: "1"
            }
          });
        },
        dataType: "xml"
      });
    },
    async: false,
    contentType: "text/xml"
  });
  langChoice = userLang;
  $('#username').text(user);
  /* CODE FOR DISPLAYING THE CLIP HISTORY */
  $("#history").overlay({
    // disable this for modal dialog-type of overlays
    // load it immediately after the construction
    top: '30%',
    load: false,
    speed: 'slow',
    close: '#close'
  });
  $(document).delegate('#close', 'click', function () {
    $('#history').overlay().close();
  });
  $(document).delegate('.status', 'click', function () {
    // determine the clip id and type 
    idToCheck = $(this).attr('id').split('-')[1];
    typeOfClip = $(this).attr('id').split('-')[2];
    statusCheck = "/exist/rest/db/tullio/" + mmm + "/locks.xml?_query=//s[@n=" + idToCheck + "][@v='" + typeOfClip + "']";
    $('#history').transform({
      xml: statusCheck,
      xsl: "xsl/format-history.xsl"
    });
    $('#history').overlay().load();
  });
  $(document).delegate('#unlock', 'click', function () {
    $.post("../xq/unlock.xql", {
      "v": typeOfClip,
      "n": idToCheck,
      "force": true,
      "m": mmm
    }, function (data) {
      // alert("Data Loaded: " + data);
    });
  });
  $("#overview").text(mmm);
  //		setupClipOverview();
  // initialize maakt events en text files aan, en vult de text file met procedure tekst
  // functie initialize zorgt voor de aanmaak van de tabel aan client side, blijkbaar noodzakelijk	
  // start displaying status codes
  // setTimeout("", 500);
  $("#text-table td.content").live("dblclick",

  function () {
    console.log('clicked');
    // console.log (this);
    $(this).removeClass('content');
    // console.log (this);
    // if (this.id == clickmemory) {alert('clip ' + clickmemory + ' already open'); return false;}
    // set some variables
    // clickmemory = this.id;
    var locked = false;
    editReqId = this.id.slice(1, -2);
    author = user;
    // author = $("#person option:selected").text();
    var textversion = $(this).hasClass("orig") ? "orig" : "trans";
    // check if the clip is unlocked
    // td needs class indicating the text version
    var request = $.ajax({
      url: "../xq/lock.xql",
      type: "POST",
      data: {
        "v": textversion,
        "n": editReqId,
        "id": author,
        "m": mmm
      },
      async: false
    });
    request.done(function (msg) {
      msgString = (new XMLSerializer()).serializeToString(msg);
      //// console.log ( msgString);
      if (msgString.indexOf('success') == '-1') {
        locked = true;
      }
    });
    request.fail(function (jqXHR, textStatus) {
      alert("Request failed: " + textStatus);
      locked = true;
    });
    // console.log ("clicked: " + this.id);
    if (locked) {
      alert("locked");
      locked = false;
      return false;
    }
    newe = $(this).offset().top;
    // check if another clip is being edited, store text and clean up
    if (edited != '') {
      var answer = confirm(msgStore.xclip[userLang])
      if (answer) {
        // don't do anything as 2nd clip is already locked
        return true;
      } else {
        $.post("../xq/unlock.xql", {
          "v": textversion,
          "n": editReqId,
          "id": author,
          "m": mmm
        }, function (data) {
          // alert("Data Loaded: " + data);
        });
        return true;
      }
      $("#cke").attr('id', '');
      $(jq(edited)).removeClass("editmode");
      var clipid = edited.slice(1, -2);
      var stop = $(jq("stopevent-" + clipid)).text();
      var cat = $(this).hasClass("orig") ? "orig" : "trans";
      var status = $(jq("status" + clipid)).text();
      var editedcontent = "<wrapper n='" + clipid + "'>" + editor.getData().replace(/[&][#]160[;]/gi, " ") + "</wrapper>";
      // console.log (editedcontent);
      // store everything on the server
      $.post("../xq/storeClipEdit.xql", {
        "status": status,
        "text": editedcontent,
        "cat": oldcat,
        "start": clipid,
        "stop": stop,
        "meeting": mmm
      }, function (data) {
        // alert("Data Loaded: " + data);
      });
      // console.log (status + cat + clipid + stop + meeting);
      var old = $(this).offset().top;
      $.post("../xq/unlock.xql", {
        "v": oldcat,
        "n": clipid,
        "id": author,
        "m": mmm
      }, function (data) {
        // alert("Data Loaded: " + data);
      });
      editor.destroy();
      $(jq(edited)).addClass("content");
    }
    // first update the row to be sure we don't loose edits...
    // we cannot set 'edited' already because the cell will not be updated then
    // so use a different var 
    preEdit = this.id;
    if (editor) editor.destroy();
    startEditor = true;
    updateVisibleTexts();
    oldcat = textversion;

  });
});

