import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DetailScreen(word: '농수산물'),
  ));
}

class DetailScreen extends StatelessWidget {
  final String word;

  DetailScreen({required this.word});

  final List<String> items = ['apple', 'banana', 'orange', 'grape'];

  @override
  Widget build(BuildContext context) {
    return DetailPage(words: items, word: word);
  }
}

class DetailPage extends StatefulWidget {
  final List<String> words;
  final String word;

  DetailPage({required this.words, required this.word});

  @override
  _DetailPageState createState() => _DetailPageState(word: word);
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController _searchController = TextEditingController();
  List<String>? _matchingWords;
  TextEditingController _consumedAmountController = TextEditingController();
  double totalAmount = 100.0;
  final String word;

  _DetailPageState({required this.word});

  void _searchWords(String query) {
    setState(() {
      _matchingWords =
          widget.words.where((word) => word.contains(query)).toList();
    });
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: '농수산물 검색'),
              onChanged: (query) {
                _searchWords(query);
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
                            _showDetailDialog(_matchingWords![index]);
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(''),
                      // Text('Detail for $word'),
                    ),
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

  void _showDetailDialog(String word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Container(
                width: 300,
                height: 366,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 33,
                      width: 300,
                    ), //blank
                    SizedBox(
                      height: 95,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Image(
                            image: AssetImage('assets/images/image_apple.jpg'),
                            width: 95,
                            height: 95,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Text(
                                    '음식 이름',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  height: 65,
                                ),
                              ],
                            ),
                          ), //text
                          SizedBox(
                            width: 43,
                          ),
                        ],
                      ),
                    ), //사진+음식이름
                    SizedBox(
                      height: 18,
                    ), //blank
                    SizedBox(
                      height: 108,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          SizedBox(
                            width: 174,
                            child: Text(
                                '1회 제공량 (100g) 당 함량\n'
                                '에너지\n'
                                '수분\n'
                                '단백질\n'
                                '지방\n'
                                '탄수화물\n',
                                style: TextStyle(fontSize: 12)),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: Text(
                              '\n'
                              'kcal\n'
                              'g\n'
                              'g\n'
                              'g\n'
                              'g\n',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            width: 23,
                          ),
                        ],
                      ),
                    ), //영양 성분 정보
                    SizedBox(
                      height: 14,
                    ), //blank
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 14,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: SizedBox(
                              width: 250,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 11,
                                  ), //공백
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ), //공백
                                        SizedBox(
                                          width: 62,
                                          child: Text(
                                            '총 섭취량',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ), //총 섭취량 텍스트
                                        SizedBox(
                                          width: 5,
                                        ), //사이 공백
                                        SizedBox(
                                          width: 125,
                                          height: 20,
                                          child: TextField(
                                            style: TextStyle(fontSize: 12),
                                            controller:
                                                _consumedAmountController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: '(1회 제공량 100g)',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 13),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
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
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  ), //총 섭취량 정보,
                                  SizedBox(
                                    height: 9,
                                  ), //공백
                                  SizedBox(
                                    height: 26,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 125,
                                        ),
                                        SizedBox(
                                          width: 115,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              //사용자가 입력한 값을 total Amount로 변환
                                              setState(() {
                                                totalAmount = double.tryParse(
                                                        _consumedAmountController
                                                            .text) ??
                                                    0.0;
                                              });
                                              //최종 totalAmount를 간직한채 Dialog를 닫음.
                                              Navigator.pop(
                                                  context, totalAmount);
                                            },
                                            child: Text('추가하기',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                )),
                                          ),
                                        ), //추가하기 버튼
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  ), //추가하기 칸
                                  SizedBox(
                                    height: 14,
                                  ), //마지막 공백
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                        ],
                      ),
                    ), //추가 박스
                    SizedBox(
                      height: 16,
                    ), //blank
                  ],
                )),
          ),
        );
      },
    );
  }
}
