import 'package:flutter/material.dart';
import 'commodity.dart';
import 'http_util.dart';
import 'listPage.dart';
import 'dart:io';

void main() {
  runApp(new MaterialApp(
      home: new DetailPage(
    detailData: Commodity(1, "abc", 1, price: 10),
  )));
}

class DetailPage extends StatefulWidget {
  final Commodity detailData;

  DetailPage({this.detailData});

  @override
  _DetailPageState createState() => _DetailPageState(detailData: detailData);
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  Commodity detailData;
  _DetailPageState({this.detailData});

  double _scale;
  AnimationController _controller;
  bool uploading = false;

  IOHttpUtils _ioHttpUtils = new IOHttpUtils();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    _showAlertDialog();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    print(_scale);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
            backgroundColor: Color(0x00000000),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: SingleChildScrollView(child: _buildDetail(context)) //避免输入框弹起时像素溢出
        );
  }

  Widget _buildDetail(BuildContext context) {
    return Column(children: <Widget>[
      Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/storage.jpg'), fit: BoxFit.cover)),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.5)),
          child: Center(
            child: Text(
              "${detailData.getImgName()}",
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
                      'Information',
                      style:
                          new TextStyle(color: Colors.red[200], fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new Text(
                      "Quantity: ${detailData.quantity}",
                      style: new TextStyle(color: Colors.blue, fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new Text(
                      "Price: ${detailData.price}",
                      style: new TextStyle(color: Colors.blue, fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/${detailData.getImgName()}.jpg'),
                              fit: BoxFit.contain)),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      child: Transform.scale(
                        scale: _scale,
                        child: _animatedButtonUI,
                      ),
                    ),
                  ])),
                ))),
      )
    ]);
  }

  Widget get _animatedButtonUI => Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.95 - 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 15.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.blue,
              ],
            )),
        child: Center(
          child: Text(
            uploading ? 'deleting...' : 'delete',
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      );

  _doDelete() async {
    _ioHttpUtils.sendDeletePost(detailData.itemId).then((_result) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListPage()));
    });
  }

  void _showAlertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Notice'),
              titleTextStyle: TextStyle(color: Colors.purple), // 标题文字样式
              content: Text(r'Are you sure to delete?'),
              contentTextStyle: TextStyle(color: Colors.green), // 内容文字样式
              backgroundColor: Colors.white,
              elevation: 8.0, // 投影的阴影高度
              semanticLabel: 'Label', // 这个用于无障碍下弹出 dialog 的提示
              shape: Border.all(),
              // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
              actions: <Widget>[
                // 点击增加显示的值
                FlatButton(onPressed: _doDelete, child: Text('yes')),
                // 点击减少显示的值
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uploading = false;
                      });
                      _controller.reverse();
                      Navigator.pop(context);
                    },
                    child: Text('no')),
              ],
            ));
  }
}
