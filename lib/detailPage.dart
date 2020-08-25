import 'package:flutter/material.dart';
import 'commodity.dart';

void main() {
  runApp(new MaterialApp(
      home: new DetailPage(
    detailData: Commodity("abc", 1, price: 10),
  )));
}

class DetailPage extends StatefulWidget {
  final Commodity detailData;

  DetailPage({this.detailData});

  @override
  _DetailPageState createState() => _DetailPageState(detailData: detailData);
}

class _DetailPageState extends State<DetailPage> {
  Commodity detailData;
  _DetailPageState({this.detailData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail"),
        ),
        body: Column(children: <Widget>[
          Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0),
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/storage.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.all(40.0),
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(color: Colors.blueGrey.withOpacity(0.5)),
              child: Center(
                child: Text(
                  "${detailData.name}",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ]),
          Center(
            child: Card(
                child: new Container(
                    color: Colors.white,
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.68,
                      padding: const EdgeInsets.all(30.0),
                      child: new Center(
                          child: new Column(children: [
                        new Padding(padding: EdgeInsets.only(top: 40.0)),
                        new Text(
                          'Item Information',
                          style:
                              new TextStyle(color: Colors.blue, fontSize: 25.0),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        new Text(
                          "Number: ${detailData.quantity}",
                          style:
                              new TextStyle(color: Colors.blue, fontSize: 25.0),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        new Text(
                          "Price: ${detailData.price}",
                          style:
                              new TextStyle(color: Colors.blue, fontSize: 25.0),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/${detailData.name}.jpg'),
                                  fit: BoxFit.contain)),
                        ),
                      ])),
                    ))),
          )
        ]));
  }
}
