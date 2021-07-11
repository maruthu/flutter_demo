import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class CalenderHome extends StatefulWidget {
  CalenderHome({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<CalenderHome> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String startDay = DateFormat('MMM, d, yyyy').format(DateTime.now());
  String endDay = DateFormat('MMM, d, yyyy').format(DateTime.now());
  String _currentMonth = DateFormat('MMM, yyyy').format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  int dayMode = 1;

  CalendarCarousel _calendarCarouselNoHeader;

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2021, 6, 10): [
        getEvent(2021, 7, 5, Colors.orange),
        getEvent(2021, 7, 5, Colors.green),
      ],
    },
  );

  static getEvent(int year, int month, int date, MaterialColor color) {
    return new Event(
      date: new DateTime(year, month, date),
      title: 'Event 2',
      icon: _eventIcon,
      dot: Container(
          margin: EdgeInsets.all(1.0),
          width: 5.0,
          height: 5.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          )),
    );
  }

  @override
  void initState() {
    _markedDateMap.add(
        new DateTime(2021, 7, 1), getEvent(2021, 6, 25, Colors.green));

    _markedDateMap.add(
        new DateTime(2021, 7, 7), getEvent(2021, 6, 25, Colors.orange));

    _markedDateMap.addAll(new DateTime(2021, 7, 4), [
      getEvent(2021, 6, 25, Colors.green),
      getEvent(2021, 6, 25, Colors.orange),
    ]);

    _markedDateMap.addAll(new DateTime(2021, 7, 10), [
      getEvent(2021, 6, 25, Colors.orange),
      getEvent(2021, 6, 25, Colors.green),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.transparent,
      onDayPressed: (DateTime date, List<Event> events) {
        var size = events.length;

        if (size > 0)
          _showToast('Found $size Transaction for selected date !!');

        this.setState(() => {
              _currentDate2 = date,
              if (dayMode == 1)
                startDay = DateFormat('MMM, d, yyyy').format(date),
              if (dayMode == 2)
                endDay = DateFormat('MMM, d, yyyy').format(date),
            });
        events.forEach((event) => print(event.title));
      },
      height: 300.0,
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: true,
      daysTextStyle: TextStyle(fontFamily: 'comfortaa', color: Colors.black),
      thisMonthDayBorderColor: Colors.transparent,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: BouncingScrollPhysics(),
      //markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.white)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),

      weekdayTextStyle: TextStyle(color: Colors.grey, fontSize: 12),
      weekDayFormat: WeekdayFormat.narrow,
      todayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(color: Colors.green, fontSize: 20),
      selectedDayBorderColor: Colors.transparent,
      selectedDayButtonColor: Colors.white,
      minSelectedDate: _currentDate.subtract(Duration(days: 3600)),
      maxSelectedDate: _currentDate.add(Duration(days: 30)),
      weekendTextStyle: TextStyle(fontFamily: 'comfortaa', color: Colors.black),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat('MMM, yyyy').format(_targetDateTime);
        });
      },

      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text('Calender Demo'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: getBoxDecor(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Download history by date : ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F456C),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          startDay + ' - ' + endDay,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F456C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  getSelectView(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    color: Color(0xffe2e4fb),
                    child: Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _currentMonth,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color(0xff6977e4),
                                  fontFamily: 'comfortaa'),
                            ),
                          ),
                          Container(
                            width: 80,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  _targetDateTime = DateTime(
                                      _targetDateTime.year,
                                      _targetDateTime.month - 1);
                                  _currentMonth = DateFormat('MMM, yyyy')
                                      .format(_targetDateTime);
                                });
                              },
                              elevation: 2.0,
                              fillColor: Color(0xffecedfa),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 30.0,
                                color: Color(0xff6977e4),
                              ),
                              shape: CircleBorder(),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  _targetDateTime = DateTime(
                                      _targetDateTime.year,
                                      _targetDateTime.month + 1);
                                  _currentMonth = DateFormat('MMM, yyyy')
                                      .format(_targetDateTime);
                                });
                              },
                              elevation: 2.0,
                              fillColor: Color(0xffecedfa),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                size: 30.0,
                                color: Color(0xff6977e4),
                              ),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(child: _calendarCarouselNoHeader),
                  ), //
                ],
              ),
            ),
          ),
        ));
  }

  static getBoxDecor() {
    return BoxDecoration(
      color: Color(0xffe2e4fb),
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[500],
          offset: Offset(4, 4),
          blurRadius: 5,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(-4, -4),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    );
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _infoSelectDate(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  static getCalenderBoxDecor() {
    return BoxDecoration(
      color: Color(0xffe2e4fb),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[500],
          offset: Offset(0, 2),
          blurRadius: 1,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ],
    );
  }

  getSelectView() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                _infoSelectDate("You are selecting start date !!!");
                setState(() {
                  dayMode = 1;
                });
              },
              child: Container(
                decoration: getCalenderBoxDecor(),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                      color: Color(0xff6977e4),
                    ),
                    Text(
                      startDay,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff6977e4),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff6977e4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                _infoSelectDate("You are selecting end date !!!");
                setState(() {
                  dayMode = 2;
                });
              },
              child: Container(
                decoration: getCalenderBoxDecor(),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                      color: Color(0xff6977e4),
                    ),
                    Text(
                      endDay,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff6977e4),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff6977e4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
