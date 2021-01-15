import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague_admin/home_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;

    switch (settings.name) {
      case 'RootPage':
        return CupertinoPageRoute(builder: (_) => HomePage());

      // case 'ClassProceedingPage':
      //   return CupertinoPageRoute(
      //       builder: (_) => ClassProceedingPage(id: arguments));

      // case 'GuestProfilePage':
      //   return CupertinoPageRoute(
      //       builder: (_) => ChangeNotifierProvider(
      //             create: (_) =>
      //                 OtherUserProfileProvider('${UserInfo.myProfile.id}'),
      //             child: GuestProfilePage(),
      //           ));

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child:
                        Text('${settings.name} 는 lib/route.dart에 정의 되지 않았습니다.'),
                  ),
                ));
    }
  }
}
