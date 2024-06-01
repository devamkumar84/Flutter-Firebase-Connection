import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:may_two/blocs/authentication.dart';
import 'package:may_two/blocs/home.dart';
import 'package:may_two/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Authentication>(
              create: (context)=> Authentication(),
          ),
          ChangeNotifierProvider<Home>(create: (context)=> Home()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'May One App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState()=> SplashScreenState();
}
class SplashScreenState extends State<SplashScreen>{
  afterSpash(){
    context.read<Authentication>();
    Future.delayed(Duration(milliseconds: 0)).then((value){
      goToHomePage();
    });
  }
  goToHomePage()async{
    final Authentication au = context.read<Authentication>();
      au.getDataFromSp();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
  }
  @override
  void initState() {
    afterSpash();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}