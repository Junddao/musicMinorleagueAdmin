import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague_admin/home_page.dart';
import 'package:music_minorleague_admin/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague_admin/route.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MiniWidgetStatusProvider>(
          create: (_) => MiniWidgetStatusProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MusicMinorLeague',
        theme: ThemeData(
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        onGenerateRoute: Routers.generateRoute,
        home: HomePage(),
      ),
    );
  }
}
