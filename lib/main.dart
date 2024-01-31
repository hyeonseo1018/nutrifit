
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
  
  final _pages =  [SearchPage(),HomePage(),Placeholder()];

 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('NutriFit',style: TextStyle(fontSize: 30),))),
      body: Navigator(
        
        onGenerateRoute: (routeSettings){
        return MaterialPageRoute(builder: (context) => _pages[selectedIndex]);
      },),
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


  



