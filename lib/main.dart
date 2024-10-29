import 'package:flutter/material.dart';
import 'package:mobile/Views/home_view.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Simple Note",
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.amberAccent ),
        useMaterial3: true,
      ),
        home: const HomeView(),
    );
  }
}
