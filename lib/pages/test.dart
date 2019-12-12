import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: 100,
                  color: Colors.deepPurple,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: 100,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 100,
            width: 100,
            color: Colors.deepOrange,
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                height: 100,
                width: 70,
                color: Colors.green,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                height: 100,
                width: 70,
                color: Colors.green,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                height: 100,
                width: 70,
                color: Colors.green,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            height: 50,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            height: 50,
            color: Colors.pink,
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            height: 50,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
