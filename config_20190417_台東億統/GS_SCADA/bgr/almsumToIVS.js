//WINEXEC("BWSPOOL.EXE");

var selectedIdx, date, time, tagname;
var dateCmdString, timeCmdString, tagnameCmdString;

//get the highlighted alarm
selectedIdx = GETVAL("%AALMSUMH");
if(selectedIdx>=0){
	//use the highlighted alarm to get the timestamp and tagname
	datecmdString = "%TALMSUMA(" + selectedIdx  +")";
	timeCmdString = "%TALMSUM3(" + selectedIdx  +")";
	tagnameCmdString = "%TALMSUM4(" + selectedIdx  +")";

	date= GETVAL(datecmdString);
	time = GETVAL(timeCmdString);
	tagname = GETVAL(tagnameCmdString);

	//use ';' as the divider in the command string
	var timeStr, dateStr;

	var timestamp, year, month, dateOnly;

	timestamp = new Date(date) ;

	year = timestamp.getYear();
	month = timestamp.getMonth();
	dateOnly = timestamp.getDate();

	var monthInt = parseInt(month);
	monthInt = monthInt + 1;

	dateStr = year + ";" + monthInt.toString() + ";" + dateOnly;

	time = time.replace(":", ";");
	timeStr = time.replace(":", ";");

	//assemble the command string here, the default mode is 1, which includes playback UI
	var cmd;
	cmd = "video=IVS_playback.vdx^tag=" + tagname + "^time=" + dateStr + ";" + timeStr + "^mode=1"

	//jump to the playback view page
	GOTODAQ(cmd);
}
