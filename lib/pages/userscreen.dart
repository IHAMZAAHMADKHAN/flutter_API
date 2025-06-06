import 'package:api2_project/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Userscreen extends StatefulWidget {
  const Userscreen({super.key});

  @override
  State<Userscreen> createState() => _UserscreenState();
}

List<UserModel> userList = [];
Future<List<UserModel>> getUserApi() async {
  List<UserModel> postList = []; // Moved inside

  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    postList.clear();
    final List<dynamic> data = jsonDecode(response.body);
    for (Map<String, dynamic> i in data) {
      postList.add(UserModel.fromJson(i));
    }
    return postList;
  } else {
    throw Exception('Failed to load data'); // Better error handling
  }
}

class _UserscreenState extends State<Userscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Screen"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserApi(),
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            reuseablerow(
                              titile: "Name",
                              value: snapshot.data![index].name.toString(),
                            ),
                            reuseablerow(
                              titile: "User Name",
                              value: snapshot.data![index].username.toString(),
                            ),
                            reuseablerow(
                              titile: "Email",
                              value: snapshot.data![index].email.toString(),
                            ),
                            reuseablerow(
                              titile: "Address",
                              value:
                                  snapshot.data![index].address!.city
                                      .toString(),
                            ),
                          ],
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

class reuseablerow extends StatelessWidget {
  String titile, value;
  reuseablerow({super.key, required this.titile, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(titile), Text(value)],
      ),
    );
  }
}
