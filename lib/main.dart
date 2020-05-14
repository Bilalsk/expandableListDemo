import 'dart:convert';

import './constants.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future sendRequest(String url, {Map body}) async {
    var result = await http.post(
      url,
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
    ).then(
      (http.Response res) {
        if (res.statusCode == 200) {
          var data = json.decode(res.body)['subjectTopicList'];

          return data;
        }

        throw Exception('Error while fetching data');
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Knowledge',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Color(0xcccccc),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var subject = data[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpandablePanel(
                          header: Padding(
                            padding: const EdgeInsets.only(top: 12, left: 10),
                            child: Text(
                              subject['subjectName'],
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          expanded: subject['topicList'].length > 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    var topic = subject['topicList'][i];

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(topic['topicTitle']),
                                    );
                                  },
                                  itemCount: subject['topicList'].length,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('No Topics'),
                                ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
              future: sendRequest(
                Constants.apiURL,
                body: {
                  'uniqueRef': 'UNIQUE-ID-2083033F',
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
