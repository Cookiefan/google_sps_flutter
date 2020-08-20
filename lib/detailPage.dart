import 'package:flutter/material.dart';
import 'commodity.dart';

void main() {
  runApp(new MaterialApp(
      home: new DetailPage(
    detailData: Commodity("abc", 1),
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
        body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          Container(
            child: Center(child: Text("name: ${detailData.name}")),
          ),
          Container(
            child: Center(
                child: Text("number: ${detailData.quantity.toString()}")),
          )
        ]));
  }
}
