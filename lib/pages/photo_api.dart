import 'package:api2_project/models/ModelPhoto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotoApi extends StatefulWidget {
  const PhotoApi({super.key});

  @override
  State<PhotoApi> createState() => _PhotoApiState();
}

Future<List<ModelPhoto>> getPostApi() async {
  List<ModelPhoto> postList = [];

  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/photos'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    for (Map<String, dynamic> i in data) {
      postList.add(ModelPhoto.fromJson(i));
    }
    return postList;
  } else {
    throw Exception('Failed to load data');
  }
}

class _PhotoApiState extends State<PhotoApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: Text("Photo API call"),
      ),
      body: FutureBuilder<List<ModelPhoto>>(
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
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image.network(
                        postList[index].url.toString(),
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(postList[index].title ?? 'No title'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
