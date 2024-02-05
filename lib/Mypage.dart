import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';
import 'Loginpage.dart';

class Mypage extends StatelessWidget {
  Future<void> delete(context) async {
    await storage.deleteAll();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginpage()));
  }

  Future _info() async {
    final response = await http.get(
        Uri.parse(
            'https://nutrifit-server-h52zonluwa-du.a.run.app/users/profile'),
        headers: {
          'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
        });
    return response.body;
  }

  Future<void> info_update(info) async {
    final url = Uri.parse(
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/update');
    await http.patch(url,
        body: jsonEncode({
          'water': 'user_id',
          'protein': 'user_password',
          'mineral': 'user_name',
          'fat': 'user_age',
          'weight': '',
          'muscle': ''
        }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _info(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final list = jsonDecode(snapshot.data);
          List<Map<String, String?>> data = [
            {'label': '체수분', 'value': '${list["water"]} L'},
            {'label': '단백질', 'value': '${list['protein']} kg'},
            {'label': '무기질', 'value': '${list['mineral']} kg'},
            {'label': '체지방', 'value': '${list['fat']} kg'},
            {'label': '체중', 'value': '${list['weight']} kg'},
            {'label': '골격근량', 'value': '${list['muscle']} kg'},
          ];
          return Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: data.map((item) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(item['label'] ?? ''),
                                    Text(item['value'] ?? ''),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(width: double.infinity),
              ),
              ElevatedButton(
                  onPressed: () {
                    delete(context);
                  },
                  child: Text('로그아웃'))
            ]),
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return CircularProgressIndicator();
      },
    );
  }
}