import 'package:flutter/material.dart';
import 'package:tale/core/services/user_service.dart';
import 'package:tale/utils/layout_manager.dart';
import 'package:tale/utils/router/router_const.dart';
import 'package:tale/utils/theme/text_theme.dart';
import 'package:tale/utils/theme/theme_manager.dart';
import 'package:tale/view/widgets/button_design.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  UserService _auth = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: ThemeManager.background,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: LayoutManager.widthNHeight0(context, 1) * 0.2,
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: LayoutManager.widthNHeight0(context, 1) * 0.7,
                    height: LayoutManager.widthNHeight0(context, 1) * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: LayoutManager.widthNHeight0(context, 1) * 0.05,
                ),
                Text(
                  "Discover The Power Of",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: LayoutManager.widthNHeight0(context, 1) * 0.075,
                      color: Colors.white,
                      fontFamily: ThemeManager.fontFamily),
                ),
                SizedBox(
                  height: LayoutManager.widthNHeight0(context, 1) * 0.008,
                ),
                GradientText(
                  'TaleBuilder',
                  gradient: ThemeManager.title,
                  style: TextStyle(
                      fontSize: LayoutManager.widthNHeight0(context, 1) * 0.075,
                      fontWeight: FontWeight.bold,
                      fontFamily: ThemeManager.fontFamily),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    "Welcome to our innovative platform, designed to transform static reports into compelling \nnarrative stories",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        wordSpacing: 1,
                        fontSize:
                            LayoutManager.widthNHeight0(context, 1) * 0.036,
                        color: Colors.white,
                        height: 1.5,
                        fontFamily: ThemeManager.fontFamily),
                  ),
                ),
                SizedBox(
                  height: LayoutManager.widthNHeight0(context, 1) * 0.14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedContainerWithShadow(
                      width: LayoutManager.widthNHeight0(context, 1) * 0.3,
                      height: LayoutManager.widthNHeight0(context, 1) * 0.13,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(signUpScreen);
                      },
                      child: Center(
                        child: GradientText(
                          'Sign Up',
                          gradient: ThemeManager.title,
                          style: TextStyle(
                            fontSize:
                                LayoutManager.widthNHeight0(context, 1) * 0.05,
                            fontFamily: ThemeManager.fontFamily,
                          ),
                        ),
                      ),
                    ),
                    OutlinedContainerWithShadow(
                      width: LayoutManager.widthNHeight0(context, 1) * 0.3,
                      height: LayoutManager.widthNHeight0(context, 1) * 0.13,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(signInScreen);
                      },
                      child: Center(
                        child: GradientText(
                          'Sign In',
                          gradient: ThemeManager.title,
                          style: TextStyle(
                            fontSize:
                                LayoutManager.widthNHeight0(context, 1) * 0.05,
                            fontFamily: ThemeManager.fontFamily,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
