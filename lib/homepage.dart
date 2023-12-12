import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'content.dart';
import 'detailpage.dart';
import 'matches_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://randomuser.me/api/?results=50"; //ランダムなユーザーを取得する
  bool isLoading =
      true; //データがロード中かどうかを示すフラグ。初期値は true で、データがロードされると false に変更される。
  late List usersData; //取得したユーザーデータを格納するためのリスト。late は、後で初期化されることを示している。
  final List<SwipeItem> _swipeItems =
      <SwipeItem>[]; //カードスワイプ機能に使用される SwipeItem オブジェクトのリスト
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = //スナックバーを表示する
      GlobalKey<ScaffoldMessengerState>();

  Future getData() async {
    var response = await http.get(
      Uri.parse(url), //URL文字列を Uri オブジェクトに変換しています。これにより、URLが正しい形式であることが確認されます。
      headers: {"Accept": "application/json"}, //APIがJSON形式でデータを返すことをサーバーに伝えるもの
    ); //外部APIからのレスポンスが格納

    List data = jsonDecode(response.body)['results']; //JSON形式のデータをデコード
    setState(() {
      //UIが変更されたことをフレームワークに通知し、再描画
      usersData = data; //外部APIから取得したデータが格納

      if (usersData.isNotEmpty) {
        //そのデータが空でない場合に処理
        for (int i = 0; i < usersData.length; i++) {
          _swipeItems.add(SwipeItem(
              // content: Content(text: _names[i], color: _colors[i]),
              content: Content(text: usersData[i]['name']['first']),
              likeAction: () {
                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("Liked "),
                  //  content: Text("Liked ${_names[i]}"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              nopeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Nope ${usersData[i]['name']['first']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              superlikeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Superliked ${usersData[i]['name']['first']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              onSlideUpdate: (SlideRegion? region) async {
                print("Region $region");
              }));
        } //for loop
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        isLoading = false;
      } //if
    }); // setState
  } // getData

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 72.0,
        titleSpacing: 36.0,
        title: Row(
          children: [
            Icon(
              Icons.photo,
              color: Colors.purple,
              size: 30,
            ),
            const Text(
              'blur',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications,
                      color: Colors.grey,
                      size: 24.0,
                    )),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.tune_sharp,
                    color: Colors.grey,
                    size: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SwipeCards(
                        matchEngine: _matchEngine!,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Card(
                                margin: const EdgeInsets.all(0),
                                shadowColor: Colors.grey,
                                elevation: 12.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      // "https://images.pexels.com/photos/3532552/pexels-photo-3532552.jpeg?cs=srgb&dl=pexels-hitesh-choudhary-3532552.jpg&fm=jpg",
                                      usersData[index]['picture']['large'],
                                      fit: BoxFit.cover, // 画像を横幅いっぱいに表示
                                      width: double.infinity, // 横幅いっぱいに広げる
                                      height: double.infinity, // 縦幅いっぱいに広げる
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent, // 上部は透明
                                        Colors.black, // 下部は黒に近い色
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  // alignment: Alignment.bottomCenter,
                                  height: 72.0,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(24.0),
                                      bottomRight: Radius.circular(24.0),
                                    ),
                                    // color: Colors.white24
                                  ),
                                  margin: const EdgeInsets.fromLTRB(
                                      24.0, 40.0, 24.0, 24.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                usersData[index]['name']
                                                        ['first'] +
                                                    ", " +
                                                    usersData[index]['dob']
                                                            ['age']
                                                        .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                usersData[index]['location']
                                                        ['city'] +
                                                    ", " +
                                                    usersData[index]['location']
                                                        ['country'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                  name: usersData[index]['name']
                                                      ['first'],
                                                  age: usersData[index]['dob']
                                                          ['age']
                                                      .toString(),
                                                  gender: usersData[index]
                                                      ['gender'],
                                                  city: usersData[index]
                                                      ['location']['city'],
                                                  state: usersData[index]
                                                      ['location']['state'],
                                                  country: usersData[index]
                                                      ['location']['country'],
                                                  phone: usersData[index]
                                                          ['phone']
                                                      .toString(),
                                                  email: usersData[index]
                                                      ['email'],
                                                  avatar: usersData[index]
                                                      ['picture']['large'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 30.0, // ボタンの幅を設定
                                            height: 30.0, // ボタンの高さを設定
                                            decoration: BoxDecoration(
                                              shape:
                                                  BoxShape.circle, // 円形の形状を指定
                                              color: Colors.grey, // 背景色を指定
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_upward,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding:
                                                EdgeInsets.zero, // パディングをゼロに設定
                                            shape: CircleBorder(), // ボタンを円形にする
                                            elevation: 8,
                                            shadowColor: Colors.black,
                                            backgroundColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        onStackFinished: () {
                          _scaffoldKey.currentState!
                              .showSnackBar(const SnackBar(
                            content: Text("Stack Finished"),
                            duration: Duration(milliseconds: 500),
                          ));
                        },
                        itemChanged: (SwipeItem item, int index) {
                          print("item: ${item.content.text}, index: $index");
                        },
                        upSwipeAllowed: true,
                        fillSpace: true,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 36,
                            ),
                            onPressed: () {
                              _matchEngine!.currentItem?.nope();
                            },
                            // child: const Text("Nope"),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 32.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 32.0,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  _matchEngine!.currentItem?.superLike();
                                },
                                //child: const Text("Superlike"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.green,
                              size: 36,
                            ),
                            onPressed: () {
                              _matchEngine!.currentItem?.like();
                            },
                            //  child: const Text("Like"),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: SizedBox(
        height: 72,
        child: ClipRRect(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // この行を追加
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            iconSize: 24.0,
            enableFeedback: true,
            mouseCursor: MouseCursor.uncontrolled,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Home",
                icon: Container(
                  child: Icon(
                    Icons.photo,
                    color: Colors.purple,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Special",
                icon: Container(
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Matches",
                icon: Container(
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Message",
                icon: Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchesIndex(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.mail_outline,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Mypage",
                icon: Container(
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
