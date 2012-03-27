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








var noReload = true;
var pagePlayer;
var offset;
var playId;

soundManager.url = '/exist/tullio/soundmanager/swf/';
// soundManager.url = '../../swf/';



// demo only..
function setTheme(sTheme) {
  var o = document.getElementsByTagName('ul')[0];
  o.className = 'playlist'+(sTheme?' '+sTheme:'');
  return false;
}

function playFromOffset(id, position) {
					console.log("offset " + offset);
					var s = soundManager.getSoundById(id);
					var tries = 0;
					
					console.log(s.readyState);
					if (s.readyState == 3) {
						console.log("ready");
						$('#alerts').addClass('hidden');
						
						
						s.resume();
						s.setPosition(offset);
					}
					else {
						$('#alerts').addClass('alert');
						if (tries < 10) {
							setTimeout("playFromOffset('" + id + "'," + offset + ")", 500);
							tries++;
						}
					}
				}


function setUpPlayer(){
		console.log("start logging");
		
		$("#reload").bind("click", function(){
				var thelink = document.getElementById('mpl');
				pagePlayer.handleClick({target: thelink});
		});
		
	
		
				$("td.sound > a").live("click", function() {
						offset = 0;
						var timeswitch = 0;
					 	noReload = false;
						
						var reference = new XDate("2011-09-05T" + $(this).children().text());
						//alert(reference);
						
						
						$(this).next().children('p.timecodes').children("span").each(function() {
								var start = new XDate("2011-09-05T" + $(this).text());
								var diff = start - reference;
								if (timeswitch == 0) {offset = diff;}
								var code = $(this).attr('id').substring(2);
								$("#offset" + code).text(toHumanTime(diff));
								timeswitch = 1;
						});
						
						
						
						
						
			var playlist = $(this).next().html();
			console.log(playlist);
			
			$("#recording").empty();
			
			$("#recording").html(playlist);
			pagePlayer.init();
			$("#recording ul").removeClass('hidden');
	//		$("#recording a").addClass('check');
	
	
			playId = $(this).next().find("a").attr('id');
			var thelink = document.getElementById(playId);
			$("#alerts").addClass('alert');
			
			pagePlayer.handleClick({target: thelink});
			soundManager.togglePause(playId);
			playFromOffset(playId, 5000);
			
			
		//	lastSound = pagePlayer.lastSound.sID;
		//	console.log(lastSound);
		//	var s = soundManager.getSoundById(lastSound);
		//	console.log(s.readyState);
		//	s.pause();
    //  s.setPosition(s.position + 1000);
	//		setTimeout("startAtOffset('" + lastSound +"')", 1000);			

// pagePlayer.handleClick({target: thelink});
			
//			soundManager.togglePause('mpl');
			//soundManager.togglePause(lastSound);
			//console.log('playing again?');
			
//			$("#recording a").trigger('click');
			/*var mySoundObject = soundManager.createSound({
					id: 'pagePlayerMP3Sound0',
					url: '../../recordings/201112250915.mp3'
			});

			soundManager.play('pagePlayerMP3Sound0');
			*/
			/*
			$(".note:contains('Start')").css({	display : 'inline-block',
																					background : '#ff9999'});
			
	
				
				*/
				
			noReload = true;			
		}
		)

		
		
		$(".load").bind("click", function(){
/*				
				function playFromOffset(id, position) {
					var offset = 2 * 60000 + 44000; 
					console.log(id + position);
					var s = soundManager.getSoundById(id);
					console.log(s.readyState);
					if (s.readyState == 3) {
						console.log("ready");
						s.setPosition(offset);


						//lastSound = pagePlayer.lastSound.sID;
						console.log('resumed');
						//soundManager.play(lastSound);
						
					}
					else {console.log('try again'); setTimeout("playFromOffset('mpl'," + offset + ")", 100);}
				}
				
	*/			
		 	noReload = false;
			var playlist = $(this).next().html();
			console.log(playlist);
			
			$("#recording").empty();
			
			$("#recording").html(playlist);
			pagePlayer.init();
			$("#recording ul").removeClass('hidden');
	//		$("#recording a").addClass('check');
	
	
			var playId = $(this).next().find("a").attr('id');
			var thelink = document.getElementById(playId);
			$("#alerts").addClass('alert');
			
			pagePlayer.handleClick({target: thelink});
			soundManager.togglePause(playId);
			playFromOffset(playId, 5000);
			
			
		//	lastSound = pagePlayer.lastSound.sID;
		//	console.log(lastSound);
		//	var s = soundManager.getSoundById(lastSound);
		//	console.log(s.readyState);
		//	s.pause();
    //  s.setPosition(s.position + 1000);
	//		setTimeout("startAtOffset('" + lastSound +"')", 1000);			

// pagePlayer.handleClick({target: thelink});
			
//			soundManager.togglePause('mpl');
			//soundManager.togglePause(lastSound);
			//console.log('playing again?');
			
//			$("#recording a").trigger('click');
			/*var mySoundObject = soundManager.createSound({
					id: 'pagePlayerMP3Sound0',
					url: '../../recordings/201112250915.mp3'
			});

			soundManager.play('pagePlayerMP3Sound0');
			*/
			/*
			$(".note:contains('Start')").css({	display : 'inline-block',
																					background : '#ff9999'});
			*/
			noReload = true;
		});
		
		
				$("#toStart").live("click", function(){
			playFromOffset(playId);
			
			
			//soundManager.togglePause(lastSound);
			//$('<li><a href="../_mp3/office_lcobby.mp3">Nog eentjen</a></li>').insertBefore('.last');
		
		
		
		});
		
		
		
		
		
		$("#startStop").live("click", function(){
			lastSound = pagePlayer.lastSound.sID;
			console.log(lastSound);
			soundManager.togglePause(lastSound);
			//$('<li><a href="../_mp3/office_lcobby.mp3">Nog eentjen</a></li>').insertBefore('.last');
		
		
		
		});
		$("#forward").live("click", function(){
			lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if (!s || !s.playState || !s.duration) {
					console.log("something wrong");
					return false;
				}
				console.log(s.position);
				s.setPosition(s.position + 5000);	
				
		});
		
		
	$("#rewind").live("click", function(){
			lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if (!s || !s.playState || !s.duration) {
					console.log("something wrong");
					return false;
				}
				console.log(s.position);
				s.setPosition(s.position - 5000);	
				
		});
		
		
		
		
		
		
		
		
		/*
		$(document).jkey('alt+=',function(){
				lastSound = pagePlayer.lastSound.sID;
				var s = soundManager.getSoundById(lastSound);
				if (!s || !s.playState || !s.duration) {
					console.log("something wrong");
					return false;
				}
				console.log(s.position);
				s.setPosition(s.position + 5000);
				
				console.log('You pressed a key.');
		});
		
		
		
		function forward() {
			lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if (!s || !s.playState || !s.duration) {
					console.log("something wrong");
					return false;
				}
				console.log(s.position);
				s.setPosition(s.position + 5000);
			//	console.log('You pressed a key.');
		}
		*/
		
		/*
		$(document).bind('keyup', 'alt+B', function() {
				console.log('hotkey pressed ');		
				lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if ( !s ) {
					console.log('no sound'); return false;
				}
				else if ( !s.playState )
				{
					console.log('playstate null'); return false;
				}
				else if ( !s.duration ) {
					console.log('duration issue'); return false;
				}
				
				console.log(s.position);
				s.setPosition(s.position + 5000);	
				
		});
		
		
				$(document).bind('keyup', 'alt+;', function() {
				
				lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if (!s || !s.playState || !s.duration) {
					console.log("something wrong");
					return false;
				}
				console.log(s.position);
				s.setPosition(s.position - 5000);	
				
		});
				
	
						
						$(document).bind('keyup', 'alt+:', function() {
				console.log('playpause key');
				lastSound = pagePlayer.lastSound.sID;
				if (!lastSound) {
					console.log('no sound');
					return false;
				}
				
				var s = soundManager.getSoundById(lastSound);
				if ( !s ) {
					console.log('no sound');
				}
				else if ( !!s.playState )
				{
					console.log('playstate null');
				}
				else if ( !s.duration ) {
					console.log('duration issue');
				}
				
				lastSound = pagePlayer.lastSound.sID;
			soundManager.togglePause(lastSound);	
				
		});
	
			*/			
						
		
}
