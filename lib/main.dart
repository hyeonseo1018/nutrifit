import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/Search_screen.dart';

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
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  var count = 0;

  void add() {
    count += 1;
    notifyListeners();
  }
  void sub(){
    count -= 1;
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
  void remove(pair){
    favorites.remove(pair);
    notifyListeners();
  }
  void goToSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
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
        page = GeneratorPage();
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

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: 
            [Flexible(flex: 5,child: Container(
              height: 300,
              
              child: Icon(
              Icons.sentiment_neutral,
              size: 180,
              
              ),),),
            Flexible(flex: 5,child: Container(height: 300,
            child: Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:80),
                  Text('열량'),
                  LinearPercentIndicator(
                  width: 130,
                  animation: true,
                  animationDuration: 1200,
                  lineHeight: 15,
                  percent: 0.7,
                  center: Text('70%',),
                  barRadius: Radius.circular(16.0),
                  ),
                  Text('수분'),
                  LinearPercentIndicator(
                  width: 130,
                  animation: true,
                  animationDuration: 1200,
                  lineHeight: 15,
                  percent: 0.5,
                  center: Text('50%',),
                  barRadius: Radius.circular(16.0),
                  ),
                  Text('탄수화물'),
                  LinearPercentIndicator(
                  width: 130,
                  animation: true,
                  animationDuration: 1200,
                  lineHeight: 15,
                  percent: 0.5,
                  center: Text('50%',),
                  barRadius: Radius.circular(16.0),
                  ),
                  Text('단백질'),
                  LinearPercentIndicator(
                  width: 130,
                  animation: true,
                  animationDuration: 1200,
                  lineHeight: 15,
                  percent: 0.8,
                  center: Text('50%',),
                  barRadius: Radius.circular(16.0),
                  ),
                  Text('지방'),
                  LinearPercentIndicator(
                  width: 130,
                  animation: true,
                  animationDuration: 1200,
                  lineHeight: 15,
                  percent: 0.8,
                  center: Text('50%',),
                  barRadius: Radius.circular(16.0),
                  ),
              ]),
            ),))],),
            SizedBox(height: 50,),
            Container(
              color: Color.fromARGB(255, 211, 210, 210),
              height: 7,
            ),
            SizedBox(height: 30,),
            SizedBox(width: double.infinity,child: Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: Text('오늘 먹은 음식',textAlign: TextAlign.left,),
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection:Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/image_burger.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                          Row(
                            children: [
                              Text('M-burger'),
                              Container(
                                
                                child: ElevatedButton(onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context) =>  SecondRoute()));
                                } , style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding:  EdgeInsets.all(3.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)
                                  )
                                ),
                                child: Text('자세히',style: TextStyle(fontSize: 10,color: Colors.black),)),
                              )
                            ],
                          ),
                          Row(children: [IconButton(onPressed: (){appState.add();}, icon: Icon(Icons.add)),
                          Text(appState.count.toString()),
                          IconButton(onPressed: (){appState.sub();}, icon: Icon(Icons.remove))
                          ],)
                          
                        ],
                      ),
                    ),
                    Image.asset('assets/images/image_sweetpotato.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                    Image.asset('assets/images/image_chicken.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                    Image.asset('assets/images/image_cider.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                    Image.asset('assets/images/image_jjamppong.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                    Image.asset('assets/images/image_salad.jpg',width:100,height: 100,fit: BoxFit.cover,),
                    
                    Image.asset('assets/images/image_tteokbokki.jpeg',width:100,height: 100,fit: BoxFit.cover,),
                  
                    
                  ]
                  ),
                ),
              
              
            )
          ],
        ),
      ),
    );
  }
}
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[Text(pair.asSnakeCase),
            SizedBox(width:20),
            ElevatedButton(onPressed: (){appState.remove(pair);}, child: Text('remove'))])
            
          ),
          
      ],
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

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asSnakeCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}