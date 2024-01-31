import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/main.dart';
import 'package:nutrifit/data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
            ElevatedButton(onPressed: (){fetchData();}, child: Text('불러오기')),
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