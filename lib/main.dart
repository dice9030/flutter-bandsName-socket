import 'package:app_flutter_avance/page/home_page.dart';
import 'package:app_flutter_avance/page/status.dart';
import 'package:app_flutter_avance/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>SocketServices(),)
          ],
          child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home':(_) => HomePage(),
          'status':(_) => StatusPage(),
        },
      ),
    );
  }
}