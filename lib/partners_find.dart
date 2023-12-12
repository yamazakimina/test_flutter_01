import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'content.dart';
import 'detailpage.dart';
import 'matches_index.dart';
import 'package:badges/badges.dart' as badges;

class PartnersFind extends StatefulWidget {
  const PartnersFind({Key? key}) : super(key: key);

  @override
  _PartnersFindState createState() => _PartnersFindState();
}

class _PartnersFindState extends State<PartnersFind> {
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
              // superlikeAction: () {
              //   _scaffoldKey.currentState?.showSnackBar(SnackBar(
              //     content: Text("Superliked ${usersData[i]['name']['first']}"),
              //     duration: const Duration(milliseconds: 500),
              //   ));
              // },
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
      appBar: appBar(),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.78,
                      child: SwipeCards(
                        matchEngine: _matchEngine!,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              card(index),
                              shadow(context),
                              nameAndAge(index, context),
                            ],
                          );
                        },
                        onStackFinished: stackFinished,
                        itemChanged: swipeChanged,
                        // upSwipeAllowed: true,
                        fillSpace: true,
                      ),
                    ),
                  ),
                  // likedButton(),
                ],
              ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: likedButton(), // 追加
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  SizedBox bottomNavigationBar(BuildContext context) {
    return SizedBox(
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
            // BottomNavigationBarItem(
            //   label: "Special",
            //   icon: Container(
            //     child: Icon(
            //       Icons.search,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            BottomNavigationBarItem(
              label: "Matches",
              icon: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchesIndex(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: badges.Badge(
                      animationDuration: Duration(milliseconds: 300),
                      badgeContent:
                          Text('3', style: TextStyle(color: Colors.white)),
                      child: Container(), // Badgeがない時にも空のコンテナを置いておくとレイアウトが崩れません
                      badgeColor: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),

            // BottomNavigationBarItem(
            //   label: "Message",
            //   icon: Container(
            //     child: GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const MatchesIndex(),
            //     ),
            //   );
            // },
            //       child: Icon(
            //         Icons.mail_outline,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),
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
    );
  }

  Row likedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'nope',
          backgroundColor: Colors.white,
          onPressed: () {
            _matchEngine!.currentItem?.nope();
          },
          shape: CircleBorder(),
          child: ShaderMask(
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 36,
            ),
            shaderCallback: (Rect rect) {
              return LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.red,
                  Colors.red,
                ],
              ).createShader(rect);
            },
          ),
        ),
        // FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   onPressed: () {
        //     _matchEngine!.currentItem?.superLike();
        //   },
        // shape: CircleBorder(),
        //   child: const Icon(
        //     Icons.star,
        //     color: Colors.blue,
        //     size: 32.0,
        //   ),
        // ),
        FloatingActionButton(
          heroTag: 'like',
          backgroundColor: Colors.white,
          onPressed: () {
            _matchEngine!.currentItem?.like();
          },
          shape: CircleBorder(),
          child: ShaderMask(
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 36,
            ),
            shaderCallback: (Rect rect) {
              return LinearGradient(
                colors: [
                  Colors.yellow,
                  Colors.green,
                  Colors.green,
                ],
              ).createShader(rect);
            },
          ),
        ),
      ],
    );
  }

  swipeChanged(SwipeItem item, int index) {
    print("item: ${item.content.text}, index: $index");
  }

  stackFinished() {
    _scaffoldKey.currentState!.showSnackBar(const SnackBar(
      content: Text("Stack Finished"),
      duration: Duration(milliseconds: 500),
    ));
  }

  Align nameAndAge(int index, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 72.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
        margin: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      usersData[index]['name']['first'] +
                          ", " +
                          usersData[index]['dob']['age'].toString(),
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
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      usersData[index]['location']['city'] +
                          ", " +
                          usersData[index]['location']['country'],
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        name: usersData[index]['name']['first'],
                        age: usersData[index]['dob']['age'].toString(),
                        gender: usersData[index]['gender'],
                        city: usersData[index]['location']['city'],
                        state: usersData[index]['location']['state'],
                        country: usersData[index]['location']['country'],
                        phone: usersData[index]['phone'].toString(),
                        email: usersData[index]['email'],
                        avatar: usersData[index]['picture']['large'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align shadow(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
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
    );
  }

  Card card(int index) {
    return Card(
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
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).canvasColor,
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
      // actions: <Widget>[
      //   Padding(
      //     padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
      //     child: Row(
      //       children: [
      //         // 通知アイコンにBadgeを追加
      //         badges.Badge(
      //           position: badges.BadgePosition.topEnd(top: 0, end: 0), // 位置
      //           animationDuration: Duration(milliseconds: 300), // アニメーションの期間
      //           badgeContent: Text('3', style: TextStyle(color: Colors.white)),
      //           child: CircleAvatar(
      //             backgroundColor: Colors.white,
      //             child: Icon(
      //               Icons.notifications,
      //               color: Colors.grey,
      //               size: 24.0,
      //             ),
      //           ),
      //           badgeColor: Colors.pink, // 数字の背景色
      //         ),
      //         CircleAvatar(
      //           backgroundColor: Colors.white,
      //           child: Icon(
      //             Icons.tune_sharp,
      //             color: Colors.grey,
      //             size: 24.0,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ],
    );
  }
}
