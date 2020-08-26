import 'package:flutter/material.dart';
import 'package:flutterapp2/listPage.dart';
import 'commodity.dart';
import 'http_util.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() {
    return _AddPageState();
  }
}

IOHttpUtils _ioHttpUtils = new IOHttpUtils();

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerQuantity = new TextEditingController();
  final TextEditingController _controllerPrice = new TextEditingController();

  double _scale;
  AnimationController _controller;
  bool uploading = false;

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

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
//        backgroundColor: Colors.transparent,
            backgroundColor: Color(0x00000000),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: SingleChildScrollView(child: _buildPage(context)) //避免输入框弹起时像素溢出
        );
  }

  Widget _buildPage(BuildContext context) {
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
              'Add Item',
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
                      style: new TextStyle(color: Colors.blue, fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 40.0)),
                    new TextField(
                      decoration: new InputDecoration(
                        labelText: "Name",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _controllerName,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new TextField(
                      decoration: new InputDecoration(
                        labelText: "Quantity",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _controllerQuantity,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new TextField(
                      decoration: new InputDecoration(
                        labelText: "Price",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _controllerPrice,
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
                    /*RaisedButton(onPressed: (){
                          print("push button");
                          print(_controllerName.text);
                          print(_controllerQuantity.text);
                          print(_controllerPrice.text);
                          _ioHttpUtils.sendDataPost(_controllerName.text, int.parse(_controllerQuantity.text), double.parse(_controllerPrice.text));
                        })*/
                  ])),
                )

                /*child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.68,
                padding: const EdgeInsets.all(20.0),
                child:Column(
                  children: <Widget>[
                    TextField(
                      controller: _controllerName,
                      decoration: new InputDecoration(
                        hintText: 'name',

                      ),
                    ),
                    TextField(
                      controller: _controllerQuantity,
                      decoration: new InputDecoration(
                        hintText: 'quantity',
                      ),
                    ),
                    TextField(
                      controller: _controllerPrice,
                      decoration: new InputDecoration(
                        hintText: 'price',
                      ),
                    ),
                    RaisedButton(onPressed: (){
                      print("push button");
                      print(_controllerName.text);
                      print(_controllerQuantity.text);
                      print(_controllerPrice.text);
                      _ioHttpUtils.sendDataPost(_controllerName.text, int.parse(_controllerQuantity.text), double.parse(_controllerPrice.text));
                    })
                  ],
                ),
              ),*/
                )),
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
            uploading ? 'uploading...' : 'submit',
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      );

  _onTapDown(TapDownDetails details) async {
    _controller.forward();
    setState(() {
      uploading = true;
    });
    _ioHttpUtils
        .sendDataPost(_controllerName.text, int.parse(_controllerQuantity.text),
            double.parse(_controllerPrice.text))
        .then((_result) {
      print("onTapDown finished");
      sleep(const Duration(milliseconds: 1000));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListPage()));
    });
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
