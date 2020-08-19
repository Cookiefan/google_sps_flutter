import 'dart:io';

import 'package:flutter/material.dart';
import 'listPage.dart';

class OpenScene extends StatefulWidget {
  _OpenSceneState createState() => _OpenSceneState();
}

class _OpenSceneState extends State<OpenScene> with SingleTickerProviderStateMixin{
  //with是dart的关键字，意思是混入的意思，就是说可以将一个或者多个类的功能添加到自己的类无需继承这些类，避免多重继承导致的问题。可以在https://stackoverflow.com/questions/21682714/with-keyword-in-dart中找到答案
  //为什么是SingleTickerProviderStateMixin呢，因为初始化animationController的时候需要一个TickerProvider类型的参数Vsync参数，所以我们混入了TickerProvider的子类SingleTickerProviderStateMixin

  AnimationController _controller;//该对象管理着animation对象
  Animation _animation;  //该对象是当前动画的状态，例如动画是否开始，停止，前进，后退。

  //初始化动画
  @override
  void initState() {
    super.initState();
    _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 3000));
    _animation=Tween(begin: 0.5,end: 1.0).animate(_controller);

    /*动画事件监听器，
    它可以监听到动画的执行状态，
    我们这里只监听动画是否结束，
    如果结束则执行页面跳转动作,跳转到home界面。 */
    _animation.addStatusListener((status){
      if(status==AnimationStatus.completed){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ListPage()), (route)=>route==null);
      }
    });
    //播放动画
    _controller.forward();
  }

  //销毁生命周期
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    //透明度动画组件
    return FadeTransition(
      opacity: _animation,//执行动画
      child: Image.asset('assets/logo.png', fit: BoxFit.cover,),

    );
  }
}