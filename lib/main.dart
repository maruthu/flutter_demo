import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'calender.dart';
import 'coinCard.dart';
import 'coinModel.dart';
import 'detailsCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListHome(),
    );
  }
}

class DetailPage extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Map<String, dynamic> json;

  String name;
  // In the constructor, require a Todo.
  DetailPage({key, this.json}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initData();
    //Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("$name"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DetailCard(json: json),
          ),
        ),
      ),
    );
  }

  initData() {
    name = json['name'];
  }
}

class ListHome extends StatefulWidget {
  @override
  _ListHomeState createState() => _ListHomeState();
}

class _ListHomeState extends State<ListHome> {
  var isDialogShown = false;

  Future<List<Coin>> fetchCoin() async {
    print('started fetching data !!');

    coinList = [];
    fullData = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
    if (isDialogShown) {
      Navigator.pop(context);
      isDialogShown = false;
    }

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      print('got data from server !!');
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
            fullData.add(map);
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  showLoaderDialog(BuildContext context) {
    isDialogShown = true;
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            color: Colors.black,
          ),
          Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("Please wait ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCoin();

    // Fetch new data and update list every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) => fetchCoin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: getHomeAppBar(),
        body: Container(
          child: getbody(),
        ));
  }

  getHomeAppBar() {
    return AppBar(
      title: Text(
        'Crypto Price Tracker',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalenderHome(),
              ),
            );
          },
          icon: Icon(Icons.date_range_rounded),
          color: Colors.white,
          iconSize: 24,
        ),
        IconButton(
          onPressed: () {
            showLoaderDialog(context);
            fetchCoin();
          },
          icon: Icon(Icons.refresh_sharp),
          color: Colors.white,
          iconSize: 24,
        ),
      ],
    );
  }

  getCalenderContainer() {
    return CalenderHome();
  }

  getbody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: coinList.length,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(json: fullData[index]),
              ),
            );
          },
          child: CoinCard(
            name: coinList[index].name,
            symbol: coinList[index].symbol,
            imageUrl: coinList[index].imageUrl,
            price: coinList[index].price.toDouble(),
            change: coinList[index].change.toDouble(),
            changePercentage: coinList[index].changePercentage.toDouble(),
          ),
        );
      },
    );
  }
}
