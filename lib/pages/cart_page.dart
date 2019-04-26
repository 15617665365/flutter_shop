import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('购物车'),
        ),
        body: Center(
          child: Row(
            children: <Widget>[
              Number(),
              MyButton(),
            ],
          ),
        ));
  }
}

class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<Counter>(builder: (context, child, counter){
        return Text(
            '${counter.value}'
        );
      })
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      child: RaisedButton(
        onPressed: () {
          Provide.value<Counter>(context).increment();
        },
        child: Text('+'),
      ),
    );
  }
}
