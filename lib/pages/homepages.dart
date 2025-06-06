import 'dart:convert';

import 'package:api2_project/models/ModelName.dart';
import 'package:api2_project/pages/photo_api.dart';
import 'package:api2_project/pages/userscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

Future<List<ModelName>> getPostApi() async {
  List<ModelName> postList = []; // Moved inside

  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );

  if (response.statusCode == 200) {
    postList.clear();
    final List<dynamic> data = jsonDecode(response.body);
    for (Map<String, dynamic> i in data) {
      postList.add(ModelName.fromJson(i));
    }
    return postList;
  } else {
    throw Exception('Failed to load data'); // Better error handling
  }
}

class _HomepagesState extends State<Homepages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("API Integration"),
        backgroundColor: Colors.cyanAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhotoApi()),
              );
            },
            icon: Icon(Icons.navigation),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Userscreen()),
              );
            },
            icon: Icon(Icons.supervised_user_circle_rounded),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final postList = snapshot.data!;
                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(postList[index].title.toString()),
                              Text(postList[index].id.toString()),
                              Text(
                                "Description\n" +
                                    postList[index].body.toString(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
