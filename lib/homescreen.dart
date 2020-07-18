import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import './slidable.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key key}) : super(key: key);

  @override
  HomescreenState createState() {
    return HomescreenState();
  }
}

class HomescreenState extends State<Homescreen> {
  File jsonFile;
  Directory dir;
  String fileName = "myFile1.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        this.setState(() {
          fileContent = json.decode(jsonFile.readAsStringSync());
          li = fileContent['list'];
          if (fileContent['list1'] != null) {
            li1 = fileContent['list1'];
          }
        });
    });
  }

  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  delete(index) {
    setState(() {
      page == 0 ? li.remove(index) : li1.remove(index);
      if (page == 0) {
        writeToFile('list', li);
      } else {
        writeToFile('list1', li1);
      }
    });
  }

  done(index) {
    setState(() {
      li1.add(index);
      li.remove(index);
      writeToFile('list', li);
      writeToFile('list1', li1);
    });
  }

  _clear() {
    setState(() {
      li1.clear();
      writeToFile('list1', li1);
    });
  }

  List<dynamic> li = [];
  List<dynamic> li1 = [];
  int page = 0;

  Future<String> createAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text('Enter Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                controller.text != null
                    ? Navigator.of(context).pop(controller.text.toString())
                    : Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.amber),
              ),
            ),
          ],
        );
      },
    );
  }

  List<TabItem> sike = List.of([
    new TabItem(Icons.assignment, "Tasks Pending", Color(0xffff0099),
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.check, "Tasks Completed", Colors.amber,
        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
  ]);
  CircularBottomNavigationController _navigationController =
      new CircularBottomNavigationController(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150.0,
              floating: true,
              pinned: true,
              backgroundColor: Colors.amber,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '           ToDo App',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                background: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xffff0099),
                    Color(0xff493240),
                  ])),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: Colors.grey[50],
                    child: Column(
                        children: page == 0
                            ? <Widget>[
                                ...li.map((item) {
                                  return Slide(
                                    title: item,
                                    delete: () => delete(item),
                                    done: () => done(item),
                                    page: page,
                                  );
                                })
                              ]
                            : <Widget>[
                                ...li1.map((item) {
                                  return Slide(
                                    title: item,
                                    delete: () => delete(item),
                                    done: () => done(item),
                                    page: page,
                                  );
                                })
                              ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: page == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                createAlert(context).then((value) {
                  setState(() {
                    String s1 = value.replaceAll(" ", "");
                    if (s1 != "") {
                      li.add(value);
                      writeToFile('list', li);
                    }
                  });
                });
              },
              label: Text('Add'),
              backgroundColor: Color(0xffff0099),
              icon: Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              onPressed: _clear,
              label: Text('Delete All'),
              backgroundColor: Colors.deepOrange,
              icon: Icon(Icons.delete_forever),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CircularBottomNavigation(
        sike,
        controller: _navigationController,
        selectedCallback: (int selectedPos) {
          if (selectedPos != page) {
            setState(() {
              page = selectedPos;
            });
          }
        },
      ),
    );
  }
}
