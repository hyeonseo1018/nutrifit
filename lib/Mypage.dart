

import 'package:flutter/material.dart';
import 'main.dart';
import 'Loginpage.dart';
import 'package:get/get.dart';

class Mypage extends StatelessWidget{

  Future<void> delete(context) async {
    await storage.deleteAll();  
  Navigator.push(context,MaterialPageRoute(builder: (context) =>  Loginpage()));
  }
  @override
  Widget build(BuildContext context){
    List<Map<String, String?>> data = [
      {'label': '체수분', 'value': '0 kg'},
      {'label': '단백질', 'value': '0 kg'},
      {'label': '무기질', 'value': '0 kg'},
      {'label': '체지방', 'value': '0 kg'},
    ];
    return Center(
      child: Column(
        children: [
          Text('나의 체성분'),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Card(child: SizedBox(
              width: double.infinity,
              child: Column(children: data.map((item){
                return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(item['label']??''),
                                Text(
                                  item['value']??'',
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
              }).toList(),)
              ,),),
          ),
          Card(child: SizedBox(width: double.infinity ),),
          ElevatedButton(onPressed: (){delete(context);}, child: Text('로그아웃'))
          ]),
    );
  }
}