import 'package:flutter/material.dart';
import 'package:tale/utils/router/router_const.dart';
import 'package:tale/view/screens/Signin/up/signin.dart';
import 'package:tale/view/screens/Signin/up/signup.dart';
import 'package:tale/view/screens/home_screens/create_chart/chart_screen.dart';
import 'package:tale/view/screens/home_screens/ocr/OCR_screen.dart';
import 'package:tale/view/screens/home_screens/document_analyze.dart';
import 'package:tale/view/screens/intro/intro_screen.dart';
import 'package:tale/view/screens/home_screens/side_screen.dart';
import 'package:tale/view/screens/menu_screens/personal.dart';
import 'package:tale/view/screens/home_screens/search_screen.dart';

import '../../view/screens/home_screens/voicescreens/voice_to_text.dart';

// Class responsible for generating routes in the application

class MyRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case introeRouteScreen:
        {
          return _route(IntroScreen());
        }
      case signInScreen:
        {
          return _route(SignIn());
        }
      case signUpScreen:
        {
          return _route(SingUp());
        }
      case sideBarScreen:
        {
          return _route(sideBar());
        }
      case searchScreen:
        {
          return _route(SearchScreen());
        }
      case personalScreen:
        {
          return _route(PersonalDetailsScreen());
        }
      case documentScreen:
        {
          return _route(DocumentAnalyze());
        }
      case voiceScreen:
        {
          return _route(VoiceToText());
        }
      case oCRScreen:
        {
          return _route(OCRScreen());
        }

      case chartScreen:
        {
          return _route(ChartScreen());
        }
      default:
        {
          final arg = settings.name as String;
          return _route(UndefineRoute(routeName: arg));
        }
    }
  }

// Helper method to create a MaterialPageRoute
  static MaterialPageRoute _route(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}

// Widget to display an undefined route error
class UndefineRoute extends StatelessWidget {
  const UndefineRoute({Key? key, required this.routeName}) : super(key: key);
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'This $routeName is Undefine Route',
        ),
      ),
    );
  }
}
