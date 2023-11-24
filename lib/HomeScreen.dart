import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/Model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String responce = '';
  List<ModelClass> QuoteList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(CategoryName),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: callAPI1(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: ListView.builder(
                itemCount: QuoteList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        QuoteList[index].quote,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('-${QuoteList[index].author}')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: Colors.green,
            height: 300,
          );
        },
      ),
    );
  }

  Future<void> callAPI1() async {
    var url = Uri.parse(
        'https://api.api-ninjas.com/v1/quotes?category=$CategoryName');
    var apiKey = '9PeOWi/rY86tzaUgTTepqA==tUKwHrndNJ06hxsF';
    for (int i = 0; i < 10; i++) {
      var response = await http.get(
        url,
        headers: {'X-API-KEY': apiKey},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List<dynamic>;

        for (var item in jsonData) {
          ModelClass modelClass = ModelClass.fromJson(item);
          QuoteList.add(modelClass);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    }
    print(QuoteList);
  }

  Future CallApI() async {
    for (int i = 0; i < 1; i++) {
      var response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=happiness'),
        headers: {'X-API-KEY': '9PeOWi/rY86tzaUgTTepqA==tUKwHrndNJ06hxsF'},
      );
      if (response.statusCode == 200) {
        responce = response.body;
        Map<String, dynamic> jsonData = jsonDecode(responce);
        ModelClass modelClass = ModelClass.fromJson(jsonData);
        QuoteList.add(modelClass);
        print(QuoteList);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }
}
