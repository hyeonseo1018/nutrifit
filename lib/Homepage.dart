import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/main.dart';
import 'package:nutrifit/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _info() async {
    final response = await http.get(
        Uri.parse(
            'https://nutrifit-server-h52zonluwa-du.a.run.app/users/profile'),
        headers: {
          'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
        });
    return response.body;
  }
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return FutureBuilder(
        future: _info(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final food_list = ['닭갈비', '치킨', '떡볶이', '짜장면'];
            //jsonDecode((snapshot.data))['food_name'].split('/');
            final list = jsonDecode(snapshot.data);
            List today_nu = [
              {'label': '열량', 'value': '${list['today_energy']}'},
              {'label': '수분', 'value': '${list['today_water']}'},
              {'label': '단백질', 'value': '${list['today_protein']}'},
              {'label': '지방', 'value': '${list['today_fat']}'},
              {'label': '탄수화물', 'value': '${list['today_carbohydrate']}'},
            ];

            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(flex: 1, child: SizedBox()),
                            Flexible(
                                flex: 1,
                                child: SizedBox(
                                  child: Column(
                                    children: today_nu.map((item) {
                                      return SizedBox(
                                          child: Column(

                                        children: [
                                          Text('${item['label']}'),
                                          LinearPercentIndicator(
                                            width: 130,
                                            animation: true,
                                            animationDuration: 1200,
                                            lineHeight: 15,
                                            percent: 0.8,
                                            center: Text(
                                              '50%',
                                            ),
                                            barRadius: Radius.circular(16.0),
                                          ),
                                        ],
                                      ));
                                    }).toList(),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(height: 30,),
                        Container(
                          color: Color.fromARGB(255, 211, 210, 210),
                          height: 7,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              '오늘 먹은 음식',
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: food_list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('${food_list[index]}'),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('error');
          }
          return CircularProgressIndicator();
        });
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
        appBar: AppBar(
          title: Text('M-burger 의 성분'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '열량 :',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '탄수화물 :',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '단백질 :',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '지방 :',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '당 :',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 30,
                            height: 30,
                            color: const Color.fromARGB(255, 215, 209, 209),
                            child: IconButton(
                                onPressed: () {
                                  appState.add();
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.add))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(appState.count.toString()),
                        ),
                        Container(
                            width: 30,
                            height: 30,
                            color: const Color.fromARGB(255, 215, 209, 209),
                            child: IconButton(
                                onPressed: () {
                                  appState.sub();
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.remove)))
                      ],
                    ),
                  ]),
            ),
          )),
        ));
  }
}
