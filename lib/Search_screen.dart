import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:nutrifit/Search_Category_Detail_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: SearchPage(),
  ));
}

class SearchPage extends StatelessWidget {
  final List<String> words = ['m-burger', 'c-burger', 'p-burger', 'l-burger'];

  @override
  Widget build(BuildContext context) {
    return SearchScreen(words: words);
  }
}

class SearchScreen extends StatefulWidget {
  final List<String> words;

  SearchScreen({required this.words});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String>? _matchingWords;
  List<dynamic>? data;
  TextEditingController _consumedAmountController = TextEditingController();
  double totalAmount = 100.0;

  Timer? _searchTimer;

  Future<void> search(String food_name, String group) async {
    final String url =
        'https://nutrifit-server-h52zonluwa-du.a.run.app/food/foodSearch';

    final http.Response response = await http.get(
      Uri.parse('${url}?food_name=${food_name}&DB_group=${group}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      List<String> foodNames = [];
      for (var item in data!) {
        String foodName = item['food_name'];
        foodNames.add(foodName);
      }
      setState(() {
        _matchingWords = foodNames as List<String>;
      });

    } else {
      print('검색 실패: ${response.reasonPhrase}');
    }
  }

  void _searchWords(String query) {
     // 이전 타이머가 있으면 취소
    _searchTimer?.cancel();

    // 새로운 타이머 시작
    _searchTimer = Timer(Duration(milliseconds: 500), () {
      print(query);
      // 500ms 후에 search 함수 호출
      search(query, '');
    });
  }

  Future<void> _add(searchdata,double totalAmount) async{
    final String url_get =
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/profile';
    final String url_post =
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/update/todays';

    final http.Response response_get =
        await http.get(Uri.parse(url_get), headers: {
      'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
    }); 
    Map<String, dynamic> dataMap = json.decode(response_get.body);
    final data = {
      //서버 바뀌면 다시..
      "todays": dataMap['todays'] +'/'+searchdata['food_name'],
      "today_energy": dataMap['today_energy'] + (double.parse(searchdata['energy_kcal'].toString())*(totalAmount/100)).floor(),
      //아마 int랑 string이랑 더할려고 한다고 오류 날 듯..
      "today_water": dataMap['today_water']+(double.parse(searchdata['water_g'].toString())*(totalAmount/100)).floor(),
      "today_protein": dataMap['today_protein']+(double.parse(searchdata['protein_g'].toString())*(totalAmount/100)).floor(),
      "today_fat": dataMap['today_fat']+(double.parse(searchdata['fat_g'].toString())*(totalAmount/100)).floor(),
      "today_carbohydrate": dataMap['today_carbohydrate']+(double.parse(searchdata['carbohydrate_g'].toString())*(totalAmount/100)).floor(),
    };
    String jsonString = json.encode(data);
    final http.Response response_post =
        await http.patch(Uri.parse(url_post), body: jsonString, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
    });    
    if(response_post.statusCode != 200){
      print('update 실패!${response_post.statusCode}');
      
    }else{
      print('update 성공!');
      print(jsonString);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //     title: Center(
      //         child: Text(
      //   'NutriFit',
      //   style: TextStyle(fontSize: 30),
      // ))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (query) async {
                _searchWords(query);
                setState(() {});
              },
            ),
            Expanded(
              child: _matchingWords != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _matchingWords!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_matchingWords![index]),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DetailScreen(
                            //       word: _matchingWords![index],
                            //     ),
                            //   ),
                            // );
                            
                            _showDetailDialog(data![index]);
                            
                            
                          },
                        );
                      },
                    )
                  : _buildGridBoxes(),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.manage_search),
      //       label: 'search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'my page',
      //     )
      //   ],
      // ),
    );
  }

  void _showDetailDialog(searchdata) {
    _consumedAmountController = TextEditingController(text: '100.0');
    totalAmount = 100.0;

    
    // searchdata['food_name'] -> '음식 이름';
    // searchdata['energy_kcal'] -> '칼로리';
    // searchdata['water_g'] -> '수분';
    // searchdata['protein_g'] -> '단백질';
    // searchdata['fat_g'] -> '지방';
    // searchdata['carbohydrate_g'] -> '탄수화물';
    // 나머지 정보도 보려면 print(searchdata)하면 됨
    List<Map<String, String?>> data = [
      {'label': '칼로리', 'value': '${searchdata["energy_kcal"]} kcal'},
      {'label': '수분', 'value': '${searchdata['water_g']} g'},
      {'label': '단백질', 'value': '${searchdata['protein_g']} g'},
      {'label': '지방', 'value': '${searchdata['fat_g']} g'},
      {'label': '탄수화물', 'value': '${searchdata['carbohydrate_g']} g'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState)
        {return Dialog(
          child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${searchdata['food_name']}'),
                        SizedBox(
                          height: 10,
                        ),
                        
                        Text(totalAmount == 100.0?'1회 제공량 (100g) 당 함량': '(${totalAmount}g)당 함량'),
                      ],
                    ),
                  ), //사진+음식이름
                  //blank
                  SizedBox(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: data.map((data) {
                            
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 8.0, 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${data['label']}'),
                                  Text('${double.parse((data['value']!.split(' '))[0])*(totalAmount/100)}' ' ${data['value']!.split(' ')[1]}')
                                ],
                              ),
                            );
                          }).toList())), //영양 성분 정보
                  SizedBox(
                    height: 14,
                  ), //blank
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '총 섭취량',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 125,
                                    height: 20,
                                    child: TextField(
                                      style: TextStyle(fontSize: 12),
                                      controller: _consumedAmountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '(1회 제공량 100g)',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 13),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          totalAmount = double.parse(value);
                                        },);
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                        height: 20,
                                        child: InkWell(
                                          onTap: () {
                                            // 버튼 클릭 시 totalAmount 변수 값 증가
                                            setState(() {
                                              totalAmount += 100;
                                              _consumedAmountController.text =
                                                  totalAmount.toString();
                                            });
                                           
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.arrow_drop_up,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 10,
                                        height: 20,
                                        child: InkWell(
                                          onTap: () {
                                            // 버튼 클릭 시 totalAmount 변수 값 증가
                                            setState(() {
                                              totalAmount -= 100;
                                              _consumedAmountController.text =
                                                  totalAmount.toString();
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            ElevatedButton(
                              onPressed: () {
                                //사용자가 입력한 값을 total Amount로 변환
                                setState(() {
                                  totalAmount = double.tryParse(
                                          _consumedAmountController.text) ??
                                      0.0;
                                });
                                _add(searchdata,totalAmount);
                                Navigator.pop(context);
                              },
                              child: Text('추가하기',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );});
      },
    );
  }

  Widget _buildGridBoxes() {
    const items = ['농축산물', '수산물', '가공식품', '음식'];
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      padding: EdgeInsets.all(24.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print(items[index]);
            _navigateToDetailScreen(items[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(items[index]),
            ),
          ),
        );
      },
    );
  }


  // Widget _buildColoredBox(String word) {
  //   return Container(
  //     margin: EdgeInsets.all(15),
  //     width: 131,
  //     height: 103,
  //     color: Colors.amber,
  //     child: TextButton(
  //       onPressed: () {
  //         filterWords(word);
  //       },
  //       child: Text(word),
  //     ),
  //   );
  // }

  void _navigateToDetailScreen(String selectedWord) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          word: selectedWord,
        ),
      ),
    );
  }

  void filterWords(String keyword) {
    setState(() {
      _matchingWords =
          widget.words.where((word) => word.contains(keyword)).toList();
    });
    // Navigate to detail page with filteredWords
  }
}

// class DetailScreen extends StatelessWidget {
//   final String word;

//   DetailScreen({required this.word});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             'NutriFit',
//             style: TextStyle(fontSize: 30),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Text('Detail for $word'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.manage_search),
//             label: 'search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'my page',
//           ),
//         ],
//       ),
//     );
//   }
// }