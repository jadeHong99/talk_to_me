import 'package:talk_to_me/authentication/authenticate.dart';
import 'package:talk_to_me/authentication/helper_functions.dart';
import 'package:talk_to_me/views/chatroom_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff145C9E),
        scaffoldBackgroundColor: const Color(0xff1F1F1F),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xff007EF4)),
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? const ChatRoom()
              : const Authenticate()
          : const Center(
              child: Authenticate(),
            ),
    );
  }
}
