// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'openScene.dart';
import 'commodity.dart';
import 'http_util.dart';
import 'addPage.dart';
import 'searchPage.dart';
import 'detailPage.dart';
import 'dart:io';

void main() => runApp(MyApp());
IOHttpUtils _ioHttpUtils = new IOHttpUtils();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '库存管理系统',
      home: OpenScene(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var resultList;
  final _suggestions = <Commodity>[];
  final _normalFont = TextStyle(fontSize: 16.0);
  final _biggerFont = TextStyle(fontSize: 22.0);

  void addNavigate() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(
        //title: Text('库存列表'),
        //),
        body: FutureBuilder(
          future: _ioHttpUtils.sendDataGet(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              print("done");
              resultList = _ioHttpUtils.getDataList();
              _suggestions.clear();
              for (var commodity in resultList) {
                _suggestions.add(Commodity(commodity["item_id"],
                    commodity["name"], commodity["number"],
                    price: commodity["price"]));
              }
              return _buildList();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: addNavigate,
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchBarDelegate(resultList));
              },
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                _ioHttpUtils.sendDataGet();
                setState(() {});
              },
              heroTag: null,
            )
          ],
        ));
  }

  Widget _buildList() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(2 * _suggestions.length + 1, (index) {
          if (index == 0)
            return Stack(
              children: <Widget>[
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
                      'Inventory List',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            );
          if (index.isOdd) return Divider();
          return _buildRow(_suggestions[index ~/ 2 - 1]);
        }),
      ),
    );
    // print("!!!");
    // return ListView.builder(
    //     padding: EdgeInsets.all(16.0),
    //     itemCount: _suggestions.length * 2,
    //     itemBuilder: /*1*/ (context, i) {
    //       if (i.isOdd) return Divider(); /*2*/

    //       final index = i ~/ 2; /*3*/
    //       return _buildRow(_suggestions[index]);
    //     });
  }

  Widget _buildRow(Commodity commodity) {
    return InkWell(
        child: Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage:
                AssetImage("assets/${commodity.getImgName()}.jpg")),
        title: Text(
          commodity.name,
          style: _biggerFont,
        ),
        subtitle: Text(
          'quantity：' + commodity.quantity.toString(),
          style: _normalFont,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailPage(detailData: commodity)));
        },
      ),
    )
        /*ListTile(
          onTap: () {
            //Scaffold.of(context).showSnackBar(SnackBar(
            //  content: Text('Tap'),
            //));
          },
          title: Text(
            commodity.name,
            style: _biggerFont,
          ),
          trailing: Text(
            commodity.quantity.toString() + "件",
            style: _normalFont,
          ),
        ),*/
        );
  }
}
