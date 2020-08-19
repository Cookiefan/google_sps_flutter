// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'openScene.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '库存管理系统',
      home: OpenScene(),
    );
  }
}

class Commodity {
  String name;
  int quantity;

  Commodity(String s, int q) {
    this.name = s;
    this.quantity = q;
  }
  @override
  String toString() {
    return 'Commodity{name: $name, quantity: $quantity}';
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _suggestions = <Commodity>[];
  final _normalFont = TextStyle(fontSize: 16.0);
  final _biggerFont = TextStyle(fontSize: 22.0);

  void addNavigate() {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OpenScene()),
          (route) => route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    _suggestions.clear();
    _suggestions.add(Commodity("book", 3));
    _suggestions.add(Commodity("apple", 16));
    _suggestions.add(Commodity("map", 35));
    _suggestions.add(Commodity("字典", 13));
    _suggestions.add(Commodity("雨伞", 240));
    _suggestions.add(Commodity("相机", 36));
    _suggestions.add(Commodity("椅子", 29));
    _suggestions.add(Commodity("中性笔", 360));
    _suggestions.add(Commodity("鱼竿", 20));
    return Scaffold(
        //appBar: AppBar(
        //title: Text('库存列表'),
        //),
        body: _buildSuggestions(),
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
              onPressed: addNavigate,
              heroTag: null,
            )
          ],
        ));
  }

  Widget _buildSuggestions() {
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
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _suggestions.length * 2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(Commodity commodity) {
    return InkWell(
      child: Card(
        child: ListTile(
          leading: FlutterLogo(size: 56.0),
          title: Text(
            commodity.name,
            style: _biggerFont,
          ),
          subtitle: Text(
            '库存件数：' + commodity.quantity.toString(),
            style: _normalFont,
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
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
