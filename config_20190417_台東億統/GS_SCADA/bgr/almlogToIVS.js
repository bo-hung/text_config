//WINEXEC("BWSPOOL.EXE");

var selectedIdx, date, time, tagname;
var dateCmdString, timeCmdString, tagnameCmdString;

//get the highlighted alarm
selectedIdx = GETVAL("%AALMLOGH");
if(selectedIdx>=0){
	//use the highlighted alarm to get the timestamp and tagname with appending description
	datecmdString = "%TALMLOG2(" + selectedIdx  +")";
	timeCmdString = "%TALMLOG3(" + selectedIdx  +")";
	tagnameCmdString = "%TALMLOG4(" + selectedIdx  +")";

	date= GETVAL(datecmdString);
	time = GETVAL(timeCmdString);
	tagname = GETVAL(tagnameCmdString);

	//separate the tagname from the description string
	var index, tagname;
	index = tagname.lastIndexOf("-");
	tagname = tagname.substring(0, index-1);

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
