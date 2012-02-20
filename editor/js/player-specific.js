var noReload = true;
var pagePlayer;

soundManager.url = '/exist/tullio/soundmanager/swf/';
// soundManager.url = '../../swf/';



// demo only..
function setTheme(sTheme) {
  var o = document.getElementsByTagName('ul')[0];
  o.className = 'playlist'+(sTheme?' '+sTheme:'');
  return false;
}

function playFromOffset(id, position) {
					console.log(id + position);
					var offset = 2 * 60000 + 44000; 
					var s = soundManager.getSoundById(id);
					console.log(s.readyState);
					if (s.readyState == 3) {
						console.log("ready");
						$('#alerts').addClass('hidden');
						
						
						s.resume();
						s.setPosition(offset);
					}
					else {
						$('#alerts').addClass('alert');
						setTimeout("playFromOffset('" + id + "'," + offset + ")", 500);
					}
				}


function setUpPlayer(){
		console.log("start logging");
		
		$("#reload").bind("click", function(){
				var thelink = document.getElementById('mpl');
				pagePlayer.handleClick({target: thelink});
		});
		
	
		
				$("td.sound > a").live("click", function() {
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
			
			$(".note:contains('Start')").css({	display : 'inline-block',
																					background : '#ff9999'});
			
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
			
			$(".note:contains('Start')").css({	display : 'inline-block',
																					background : '#ff9999'});
			
			noReload = true;
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
		$(document).bind('keyup', 'alt+=', function() {
				
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
				
						$(document).bind('keyup', 'alt+=', function() {
				
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
	
						
						$(document).bind('keyup', 'alt+:', function() {
				console.log('playpause key');
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
				lastSound = pagePlayer.lastSound.sID;
			soundManager.togglePause(lastSound);	
				
		});
	
						
						
		
}
