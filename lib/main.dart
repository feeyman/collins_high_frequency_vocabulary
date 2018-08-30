import 'package:flutter/material.dart';
import 'package:collins_vocabulary/components/category.dart';
import 'package:collins_vocabulary/components/wordcard.dart';
import 'package:collins_vocabulary/components/setting.dart';
import 'package:collins_vocabulary/model/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '柯林斯高频词汇',
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.cyan[300],
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageState();
  }
}
class HomePageState extends State<HomePage>{
  DBClient client;
  Widget TabView = null;
  SharedPreferences prefs;
  int currentIndex = 0;
  int level = 5;
  
  void initDB() async{
    client = new DBClient();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt('level');
    if(level==null){
      prefs.setInt('level', 5);
      prefs.setInt('count', 50);
      prefs.setBool('showcollins',true);
      prefs.setBool('sentence',true);
      prefs.setBool('showCn',true);
      prefs.setBool('autoplay',true);
      prefs.setBool('en_ph',true);
    }
    prefs.remove('studied');
    final studied = prefs.getString('studied');
    if(studied==null){
      prefs.setString('studied', '');
      prefs.setInt('studying', 0);
    }
    setState((){
      TabView = new RememberVocab(prefs:prefs, client: client);
    });
  }
  
  @override
  void initState() {
    super.initState();
    initPrefs();
    initDB();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void _onTap(int index){
    setState((){
        currentIndex = index;
        switch(currentIndex) {
          case 0:
            TabView = new RememberVocab(prefs:prefs, client: client);
            break;
          case 1:
            TabView = new WordList(prefs:prefs);
            break;
          case 2:
            TabView = new Mine(prefs:prefs);
            break;
          default:
            TabView = new RememberVocab(client: client);
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: TabView,
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTap,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home,size: 24.0,),
                title: new Text('背单词',style: new TextStyle(fontSize: 12.0)),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.library_books,size: 24.0,),
              title: new Text('列表',style: new TextStyle(fontSize: 12.0),),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle,size: 24.0,),
              title: new Text('我的',style: new TextStyle(fontSize: 12.0),),
            ),
          ]
      )
    );
  }
}