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
        body: Column(children: <Widget>[
          Text("name: ${detailData.name}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text("number: ${detailData.quantity.toString()}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain, // otherwise the logo will be tiny
              child: const FlutterLogo(),
            ),
          ),
        ]));
  }
}
