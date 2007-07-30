
/** 
 * General Data class designed to load, store and process data.
 * Last Updated: 10.06.05
 */

class com.a12.modules.Calendar
{
	
	public var _month:Number;
	public var _year:Number;
	public var _day:Number;
	public var _lang:String;
	public var _monthDays:Array;
	private var _monthNames:Object = {};
	private var _dayNames:Object = {};
	
	public function Calendar(year:Number, month:Number, day:Number, lang:String)
	{
		var today = new Date();
		if (year == undefined) _year = today.getFullYear();
		if (month == undefined) _month = today.getMonth();
		if (day == undefined) _day = today.getDate();
		if (lang == undefined) _lang = "en";
		
		_monthNames.en = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		_monthNames.es = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "deciembre"];
		_dayNames.en = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		_dayNames.es = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"];
		
	}
	
	public function set year(year:Number) : Void
	{
		_year = year;
	}
	public function get year() : Number
	{
		return(_year);
	}
	
	public function set month(month:Number) : Void
	{
		_month = month;
	}
	public function get month() : Number
	{
		return(_month);
	}
	
	public function set day(day:Number) : Void
	{
		_day = day;
	}
	public function get day() : Number
	{
		return(_day);
	}
	
	public function set lang(lang:String) : Void
	{
		_lang = lang;
	}
	public function get lang() : String
	{
		return(_lang);
	}
	
	public function getDaysInMonth(year:Number, month:Number) : Number
	{
		if (year == undefined) year = _year;
		if (month == undefined) month = _month;
		
		if (((year % 4 == 0) && !(year % 100 == 0)) || (year % 400 == 0)) {
			_monthDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		}
		else {
			_monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		}
		return _monthDays[month];
	}
	
	public function advanceMonth(direction:Number) : Void
	{
	
		if ((_month == 11) && (direction == 1)) {
			_year++;
			_month = 0;
		}
		else if ((_month == 0) && (direction == -1)) {
			_year--;
			_month = 11;
		}
		else {
			_month = _month + direction;
		}	
	
	}
	
	public function isInMonth(dateTime:String, year:Number, month:Number) : Boolean
	{
		if (year == undefined) year = _year;
		if (month == undefined) month = _month;
		
		if (parseYear(dateTime) == year && parseMonth(dateTime) == month + 1 ) {
			return(true);
		} else {
			return(false);
		}
	}
	
	public function parseDateTime(dateTime:String) : Array
	{
		var year = parseYear(dateTime);
		var month = parseMonth(dateTime);
		var day = parseDay(dateTime);
		var time = parseTime(dateTime);
		var dateTimeArray = [year, month, day, time];
		return(dateTimeArray);
	}
	
	public function getMonthName(month:Number) : String
	{
		if (month == undefined) month = _month;
		if (_lang == "es") {
			return(_monthNames.es[month]);
		} else {
			return(_monthNames.en[month]);
		}
	}
	
	public function getDayName(year:Number, month:Number, day:Number, type:String) : String
	{
		if (year == undefined) year = _year;
		if (month == undefined) month = _month;
		if (day == undefined) day = _day;
		
		var tempDate = new Date();
		tempDate.setYear(year);
		tempDate.setMonth(month);
		tempDate.setDate(day);
		
		if (_lang == "es") {
			return(_dayNames.es[tempDate.getDay()]);
		} else {
			return(_dayNames.en[tempDate.getDay()]);
		}
	}
	
	public function parseYear(dateTime:String) : Number
	{
		var dtArray:Array = dateTime.split(" ");
		var dArray:Array = dtArray[0].split("-");
		return(Number(dArray[0]));
	}
	
	public function parseMonth(dateTime:String) : Number
	{
		var dtArray:Array = dateTime.split(" ");
		var dArray:Array = dtArray[0].split("-");
		return(Number(dArray[1]));
	}
	
	public function parseDay(dateTime:String) : Number
	{
		var dtArray:Array = dateTime.split(" ");
		var dArray:Array = dtArray[0].split("-");
		return(Number(dArray[2]));
	}
	
	public function parseTime(dateTime:String) : Array
	{
		var dtArray:Array = dateTime.split(" ");
		var tArray:Array = dtArray[1].split(":");
		return(tArray);
	}

}


