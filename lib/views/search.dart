import 'package:talk_to_me/helpers/constants.dart';
import 'package:talk_to_me/services/database.dart';
import 'package:talk_to_me/views/chatting_view.dart';
import 'package:talk_to_me/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.documents[index].data["userName"],
                searchResultSnapshot.documents[index].data["userEmail"],
              );
            })
        : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChattingView(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: const Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          style: simpleTextStyle(),
                          decoration: const InputDecoration(
                              hintText: "search username ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/images/search_white.png",
                              height: 25,
                              width: 25,
                            )),
                      )
                    ],
                  ),
                ),
                userList()
              ],
            ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}
