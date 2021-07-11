import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  DetailCard({
    @required this.json,
  });

  Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                height: 100,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(json['image']),
                ),
              ),
            ),
            getRow("Name ", json['name']),
            getRow("Rank ", '#' + json['market_cap_rank'].toString()),
            getRow("Symbol ", json['symbol']),
            getRow("Id ", json['id']),
            getRow("Last Updated", json['last_updated'].toString()),
            getRow("Current Price ", '\$ ' + json['current_price'].toString()),
            getRow("Market Cap ", '\$ ' + json['market_cap'].toString()),
            getRow("Price Change", '\$ ' + json['price_change_24h'].toString()),
            getRow("Price Change",
                json['price_change_percentage_24h'].toString() + '% in 24 Hr'),
            getRow("High 24H ", json['high_24h'].toString()),
            getRow("Low 24H ", json['low_24h'].toString()),
            getRow("Total Volume ", json['total_volume'].toString()),
            getRow("Fully Diluted Volume ",
                json['fully_diluted_valuation'].toString()),
            getRow("Total Supply", json['total_supply'].toString()),
            getRow("Circulating Supply", json['circulating_supply'].toString()),

            /*
   "market_cap_change_24h":4073252019,
   "market_cap_change_percentage_24h":0.6434,
   "circulating_supply":18749500.0,
   "total_supply":21000000.0,
   "max_supply":21000000.0,
   "ath":64805,
   "ath_change_percentage":-47.59481,
   "ath_date":"2021-04-14T11:54:46.763Z",
   "atl":67.81,
   "atl_change_percentage":49983.38167,
   "atl_date":"2013-07-06T00:00:00.000Z",
   "roi":null,
   "last_updated":"2021-07-06T17:18:22.826Z"
            * */
          ],
        ),
      ),
    );
  }

  Widget getRow(String name, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(4, 4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
