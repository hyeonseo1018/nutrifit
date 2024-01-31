
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/Search_screen.dart';
import 'package:nutrifit/Homepage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var count = 0;

  void add() {
    count += 1;
    notifyListeners();
  }
  void sub(){
    count -= 1;
    notifyListeners();
  }



}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex){
      case 0:
        page = SearchPage();
        break;
      case 1:
        page = HomePage();
        break;
      case 2:
        page = Placeholder();
        break;

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('NutriFit',style: TextStyle(fontSize: 30),))),
      body: Expanded(child: Container(child:page)),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.manage_search),label: 'search',),
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home',),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'my page',)
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,

        ),
    );
  }
}

  

class SecondRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();


    return Scaffold(
      appBar: AppBar(title:Text('M-burger 의 성분'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                
                SizedBox(height: 50,),
                Text('열량 :',style: TextStyle(fontSize: 18),),
                Text('탄수화물 :',style: TextStyle(fontSize: 18),),
                Text('단백질 :',style: TextStyle(fontSize: 18),),
                Text('지방 :',style: TextStyle(fontSize: 18),),
                Text('당 :',style: TextStyle(fontSize: 18),),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: const Color.fromARGB(255, 215, 209, 209),
                      child: IconButton(onPressed: (){appState.add();}, 
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
                      child: IconButton(onPressed: (){appState.sub();}, 
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.remove)))
                    ],),
              ]),
          ),
        )
        ),
      )
      );
  }
  
}

