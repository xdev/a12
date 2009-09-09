package com.a12.modules
{

	public class Calendar
	{
		public var _date:Date;
		public var _month:Number;
		public var _year:Number;
		public var _day:Number;
		public var _lang:String;
		public var _monthDays:Array;
		private var _monthNames:Object = {};
		private var _monthNamesShort:Object = {};
		private var _dayNames:Object = {};		
	
		public function Calendar(year:Number=NaN, month:Number=NaN, day:Number=NaN, lang:String="en")
		{
			_date = new Date();
			isNaN(year) ? _year = _date.getFullYear() : _year = year;
			isNaN(month) ? _month = _date.getMonth() : _month = month;
			isNaN(day) ? _day = _date.getDate() : _day = day;
			_lang = lang;
		
			_monthNames.en = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
			_monthNamesShort.en = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			_monthNames.es = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "deciembre"];
			_dayNames.en = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
			_dayNames.es = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"];
		
		}
		
		//getter/setters - do we still need them?
		public function get dateObj():Date
		{
			return _date;
		}
		
		public function set year(year:Number):void
		{
			_year = year;
		}
		
		public function get year():Number
		{
			return _year;
		}
	
		public function get year2():Number
		{
			var t:String = _year.toString();
			return Number(t.substr(2,2));
		}
	
		public function set month(month:Number):void
		{
			_month = month;
		}
		
		public function get month():Number
		{
			return _month;
		}
	
		public function set day(day:Number):void
		{
			_day = day;
		}
		
		public function get day():Number
		{
			return _day;
		}
	
		public function set lang(lang:String):void
		{
			_lang = lang;
		}
		
		public function get lang() : String
		{
			return _lang;
		}
		
		//interface
		public function getDaysInMonth(year:Number=NaN, month:Number=NaN):Number
		{
			isNaN(year) ? year = _year : year = year;
			isNaN(month) ? month = _month : month = month;
		
			if (((year % 4 == 0) && !(year % 100 == 0)) || (year % 400 == 0)) {
				_monthDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			}
			else {
				_monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			}
			return _monthDays[month];
		}
		
		/*
		
		public static function ChangeTimezone(dt:Date, timezone:Number):Date {
					var blnIsDST:Boolean = (dt.getTimezoneOffset() < new Date(2000, 0, 1).getTimezoneOffset());
					dt.minutes += dt.getTimezoneOffset();
					dt.minutes -= timezone * 60;
					dt.minutes += blnIsDST ? 60 : 0;

					return dt;
				}
		
		public static function GetDaysInMonth(month:uint, year:int = -1):uint {
					if (year == -1) {
						year = new Date().fullYear;
					}

					if (month == 11) {
						return new Date(year, 0, 0).date;
					}

					return new Date(year, month + 1, 0).date;
				}
		*/
		
		public function getFirstDayInMonth(year:Number=NaN, month:Number=NaN):Number
		{
			isNaN(year) ? year = _year : year = year;
			isNaN(month) ? month = _month : month = month;
		
			var tempDate:Date = new Date();
			tempDate.setFullYear(year);
			tempDate.setMonth(month);
			tempDate.setDate(1);
		
			return tempDate.getDay();
		}
		
		//should really use calendar math with constants			
		public function advanceMonth(direction:Number):void
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
	
		public function isInMonth(dateTime:String, year:Number=NaN, month:Number=NaN):Boolean
		{
			isNaN(year) ? year = _year : year = year;
			isNaN(month) ? month = _month : month = month;
		
			if (parseYear(dateTime) == year && parseMonth(dateTime) == month + 1 ) {
				return(true);
			} else {
				return(false);
			}
		}
	
		public function parseDateTime(dateTime:String):Array
		{
			var year:int = parseYear(dateTime);
			var month:int = parseMonth(dateTime);
			var day:int = parseDay(dateTime);
			var time:Object = parseTime(dateTime);
			var dateTimeArray:Array = [year, month, day, time];
			return(dateTimeArray);
		}
	
		public function getMonthName(month:Number=NaN):String
		{
			isNaN(month) ? month = _month : month = month;
			if (_lang == "es") {
				return(_monthNames.es[month]);
			} else {
				return(_monthNames.en[month]);
			}
		}
	
		public function getMonthNameShort(month:Number=NaN):String
		{
			isNaN(month) ? month = _month : month = month;
			if (_lang == "es") {
				return(_monthNames.es[month]);
			} else {
				return(_monthNamesShort.en[month]);
			}
		}
	
		public function getDayNameSimple(day:Number):String
		{
			return(_dayNames.en[day]);
		}
	
		public function getDayName(year:Number=NaN, month:Number=NaN, day:Number=NaN, type:String=''):String
		{
			isNaN(year) ? year = _year : year = year;
			isNaN(month) ? month = _month : month = month;
			isNaN(day) ? day = _day : day = day;
		
			var tempDate:Date = new Date();
			tempDate.setFullYear(year);
			tempDate.setMonth(month);
			tempDate.setDate(day);
		
			if (_lang == "es") {
				return _dayNames.es[tempDate.getDay()];
			} else {
				return _dayNames.en[tempDate.getDay()];
			}
		}
	
		public function parseYear(dateTime:String):int
		{
			var dtArray:Array = dateTime.split(" ");
			var dArray:Array = dtArray[0].split("-");
			return int(dArray[0]);
		}
	
		public function parseMonth(dateTime:String):int
		{
			var dtArray:Array = dateTime.split(" ");
			var dArray:Array = dtArray[0].split("-");
			return int(dArray[1]);
		}
	
		public function parseDay(dateTime:String):int
		{
			var dtArray:Array = dateTime.split(" ");
			var dArray:Array = dtArray[0].split("-");
			return int(dArray[2]);
		}
	
		public function parseTime(dateTime:String):Array
		{
			var dtArray:Array = dateTime.split(" ");
			var tArray:Array = dtArray[1].split(":");
			return tArray;
		}
	
		public function formatDateTime(dateTime:String):Object
		{
			//
			var tObj:Object = {};
			tObj.year = parseYear(dateTime);
			tObj.month = parseMonth(dateTime);
			tObj.monthName = getMonthName(tObj.month-1);
			tObj.monthNameShort = getMonthNameShort(tObj.month-1);
			tObj.day = parseDay(dateTime);
			tObj.dayName = getDayName(tObj.year,(tObj.month-1),tObj.day);
			var t_time:Object = parseTime(dateTime);
		
			tObj.hour = t_time[0];
			tObj.meridiem = 'AM';
			tObj.minute = t_time[1];
			tObj.second = t_time[2];
		
			if(t_time[0] >= 12){
				tObj.meridiem = 'PM';
				if(t_time[0] > 12){
					tObj.hour = t_time[0] - 12;
				}
			}
				
			if(t_time[0] == 0){
				tObj.hour = 12;
			}
		
			var d:Array = dateTime.split(" ");
			tObj.date = d[0];
			tObj.time = t_time.join(':');
		
			return tObj;
		
		}

	}

}
