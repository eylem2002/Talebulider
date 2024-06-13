import 'package:flutter/material.dart';
import 'package:tale/utils/layout_manager.dart';
import 'package:tale/utils/theme/text_theme.dart';
import 'package:tale/utils/theme/theme_manager.dart';
import 'package:tale/view/widgets/card_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu, color: ThemeManager.primary),
          onPressed: () {
            ///back
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle, color: ThemeManager.primary),
            onPressed: () {
              ///back
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF0A061C),
                Color(0xFF110A27),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF0A061C),
              Color(0xFF110A27),
              Color(0xFF140B2C),
              Color(0xFF180D32),
              Color(0xFF1D103A),
              Color(0xFF20113D),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: LayoutManager.widthNHeight0(context, 1) * 0.035,
              right: LayoutManager.widthNHeight0(context, 1) * 0.035,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  'TaleBuilder',
                  gradient: ThemeManager.title,
                  style: TextStyle(
                    fontSize: LayoutManager.widthNHeight0(context, 1) * 0.085,
                    fontFamily: ThemeManager.fontFamily,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: LayoutManager.widthNHeight0(context, 1) * 0.003,
                    left: LayoutManager.widthNHeight0(context, 1) * 0.09,
                  ),
                  child: GradientText(
                    'Build, Share, and Enjoy',
                    gradient: ThemeManager.title,
                    style: TextStyle(
                      fontSize: LayoutManager.widthNHeight0(context, 1) * 0.045,
                      fontFamily: ThemeManager.fontFamily,
                    ),
                  ),
                ),
                SizedBox(
                  height: LayoutManager.widthNHeight0(context, 1) * 0.065,
                ),
                //Search bar
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ThemeManager.second.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(color: ThemeManager.second),
                    decoration: InputDecoration(
                      hintText: 'How we can help you?',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            LayoutManager.widthNHeight0(context, 1) * 0.04,
                        vertical:
                            LayoutManager.widthNHeight0(context, 1) * 0.03,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        onPressed: () {
                          //back
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: LayoutManager.widthNHeight0(context, 1) * 0.09,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDesign(
                          width: LayoutManager.widthNHeight0(context, 1) * 0.43,
                          height: LayoutManager.widthNHeight0(context, 1) * 0.6,
                          onTap: () {},
                          child:Padding(
                            padding:  EdgeInsets.all(LayoutManager.widthNHeight0(context, 1) * 0.05),
                            child: Column(children: [
                               GradientText(
                              'Sign Up',
                              gradient: ThemeManager.title,
                              style: TextStyle(
                                fontSize:
                                    LayoutManager.widthNHeight0(context, 1) *
                                        0.05,
                                fontFamily: ThemeManager.fontFamily,
                              ),
                            ),
                            ],),
                          )
                        ),
                        //second card
                        CardDesign(
                          width: LayoutManager.widthNHeight0(context, 1) * 0.43,
                          height: LayoutManager.widthNHeight0(context, 1) * 0.6,
                          onTap: () {},
                          child: Center(
                            child: GradientText(
                              'Sign Up',
                              gradient: ThemeManager.title,
                              style: TextStyle(
                                fontSize:
                                    LayoutManager.widthNHeight0(context, 1) *
                                        0.05,
                                fontFamily: ThemeManager.fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: LayoutManager.widthNHeight0(context, 1) * 0.06,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDesign(
                          width: LayoutManager.widthNHeight0(context, 1) * 0.43,
                          height: LayoutManager.widthNHeight0(context, 1) * 0.6,
                          onTap: () {},
                          child: Center(
                            child: GradientText(
                              'Sign Up',
                              gradient: ThemeManager.title,
                              style: TextStyle(
                                fontSize:
                                    LayoutManager.widthNHeight0(context, 1) *
                                        0.05,
                                fontFamily: ThemeManager.fontFamily,
                              ),
                            ),
                          ),
                        ),
                        CardDesign(
                          width: LayoutManager.widthNHeight0(context, 1) * 0.43,
                          height: LayoutManager.widthNHeight0(context, 1) * 0.6,
                          onTap: () {},
                          child: Center(
                            child: GradientText(
                              'Sign Up',
                              gradient: ThemeManager.title,
                              style: TextStyle(
                                fontSize:
                                    LayoutManager.widthNHeight0(context, 1) *
                                        0.05,
                                fontFamily: ThemeManager.fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}