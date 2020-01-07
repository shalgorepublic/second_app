import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<String> names = [];
  TextEditingController name = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Task Page"),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: 'Enter names'),
                ),
                ScopedModelDescendant<MainModel>(
                    builder: (context, Widget child, MainModel model) => Column(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  names.add(name.text);
                                });
                              },
                              child: Text("SAVE"),
                            ),
                            RaisedButton(
                              onPressed: () {
                                model.save(names);
                              },
                              child: Text("Submit"),
                            )
                          ],
                        )),
                Text(names.length.toString()),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                CircularProgressIndicator(backgroundColor: Colors.blue),
                Divider(),
                // LinearProgressIndicator(),
                Card(
                    margin: EdgeInsets.all(30.0),
                    child: Container(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                print("press me");
                              },
                              child: Text(
                                "Pressing me",
                                style:
                                    TextStyle(fontSize: 22, color: Colors.blue,decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.solid),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("Clicked me");
                              },
                              child: Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(25.0),
                                color: Colors.red,
                                child: Text("helo world Clicking me",style: TextStyle(fontSize: 29,decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed),),
                              ),
                            ),
                            VerticalDivider(),
                            Container(
                              height: 1,
                              width: double.maxFinite,
                              color: Colors.grey,
                            ),
                            Container(color: Colors.black, height: 50, width: 2,),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(20.0),
                              color: Colors.red,
                              child: Text("helo world"),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(15.0),
                              color: Colors.red,
                              child: Text("helo world"),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(10.0),
                              color: Colors.red,
                              child: Text("helo world"),
                            ),
                            IntrinsicHeight(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Foo'),
                                    Container(color: Colors.black, height: 20, width: 2,),
                                    Text('Bar'),
                                    Container(color: Colors.black, height: 20, width: 2,),
                                    Text('Baz'),

                                  ],
                                )),
                            Container(
                              color: Colors.blueAccent,
                              padding: new EdgeInsets.all(32.0),
                              child:  LinearProgressIndicator(),
                            ),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red, //                   <--- border color
                        width: 5.0,
                      ),
                    ),
                        //             <--- BoxDecoration here
                    child: Text(
                      "text",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  )
                          ],
                        ))),
              ],
            )
          ],
          padding: EdgeInsets.all(10.0),
        ));
  }
}
