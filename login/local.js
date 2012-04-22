$(document).ready(function(){
    setInterval(doBeakerMan,5500);
    var wh = $(document).height();
    var ch = $('#coder').height();
    var calh = (parseInt(wh) - parseInt(ch) - 20) / 2;
    $('#coder').css('margin-top',calh+'px');
    type($('#coder').text(), true);
    $('#coder').text('');
});
doBeakerMan = function(){
    var limit = parseInt($("body").width());
    offset = Math.floor(Math.random()*limit);
    if (offset >= limit - 128) offset = offset - 128;
    setTimeout(function(){
        $('#beaker').fadeOut(500);
    }, 500);
    setTimeout(function(){
        $('#beaker').css('right',offset);
        $('#beaker').fadeIn(1500);
    }, 1500);
}
function type(str, cursor) {
    if (cursor === true) {
        $('#coder').append('|');
        setTimeout('type("' + str + '", false)', 175);
    } else {
        $('#coder').text($('#coder').text().replace('|', ''));
        $('#coder').append(str.substring(0, 1));
        if (str.length > 1) {
            setTimeout('type("' + str.substring(1) + '", true)', 175);
        } else {
            setTimeout(fct, 250);
        }
    }
}
function fct() {
    var clone = $('#coder').clone();
    $('#coder').parent().append(clone);
    $(clone).hide();
    $(clone).attr('id', '#coder2');
    $(clone).html('&nbsp;echo "<a href="http://' + $('#coder').text() + '">' + $('#coder').text() + '</a>";&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    $('#coder').fadeOut(900);
    $(clone).fadeIn(2700);
}
