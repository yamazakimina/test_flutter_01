import 'package:flutter/material.dart';
import 'dart:async';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'content.dart';
import 'user_show.dart';
import 'matches_index.dart';
import 'package:badges/badges.dart' as badges;
import 'test.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// 初期設定
class PartnersFind extends StatefulWidget {
  const PartnersFind({Key? key}) : super(key: key);

  @override
  _PartnersFindState createState() => _PartnersFindState();
}

class CardStatus {
  String swipeStatus = "";
  CardStatus();
}

//ランダムなユーザーを取得する
class _PartnersFindState extends State<PartnersFind> {
  String swipeStatus = "";
  bool isLoading = true;
  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  List<CardStatus> cardStatuses = [];
  List<int> currentImageIndices = []; // 画像のインデックスを格納するリスト
  List<int> currentVideoIndices = []; // 動画のインデックスを格納するリスト
  List<int> currentMediaIndices = []; // 画像と動画のインデックスを格納するリスト

  @override
  void initState() {
    super.initState();
    getData();
  }

  void nextImage(int index) {
    setState(() {
      // 現在の画像のインデックスを更新
      currentImageIndices[index] = ((currentImageIndices[index] + 1) %
          usersData[index]['pictures'].length) as int;
    });
  }

  void nextVideo(int index) {
    setState(() {
      currentVideoIndices[index] = ((currentVideoIndices[index] + 1) %
          usersData[index]['videos'].length) as int;
    });
  }

  void nextMedia(int index) {
    setState(() {
      int totalPictureCount = usersData[index]['pictures'].length;
      int totalVideoCount = usersData[index]['videos'].length;
      int totalMediaCount = totalPictureCount + totalVideoCount;

      currentMediaIndices[index] =
          (currentMediaIndices[index] + 1) % totalMediaCount;

      if (currentMediaIndices[index] < totalPictureCount) {
        // 現在のメディアが画像の場合
        currentImageIndices[index] = currentMediaIndices[index];
      } else {
        // 現在のメディアが動画の場合
        currentVideoIndices[index] =
            (currentMediaIndices[index] - totalPictureCount) % totalVideoCount;
      }
    });
  }

  Future getData() async {
    setState(() {
      isLoading = true;
      usersData = testUserData; // test.dart で定義されたテストデータ
      // usersDataが更新されたら、currentImageIndicesも更新
      currentImageIndices = List.filled(usersData.length, 0);
      currentVideoIndices = List.filled(usersData.length, 0);
      currentMediaIndices = List.filled(usersData.length, 0);
      if (usersData.isNotEmpty) {
        //そのデータが空でない場合に処理
        for (int i = 0; i < usersData.length; i++) {
          cardStatuses.add(CardStatus());
          _swipeItems.add(SwipeItem(
              content: Content(text: usersData[i]['name']),
              likeAction: () {
                setState(() {
                  swipeStatus = "LIKE";
                });
                _matchEngine!.currentItem?.like();

                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("LIKE"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              nopeAction: () {
                setState(() {
                  swipeStatus = "NOPE";
                });
                _matchEngine!.currentItem?.nope();

                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("NOPE"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              onSlideUpdate: (SlideRegion? region) async {
                if (region == SlideRegion.inNopeRegion) {
                  setState(() {
                    cardStatuses[i].swipeStatus = "NOPE";
                  });
                } else if (region == SlideRegion.inLikeRegion) {
                  setState(() {
                    cardStatuses[i].swipeStatus = "LIKE";
                  });
                } else {
                  setState(() {
                    cardStatuses[i].swipeStatus = "";
                  });
                }
              }));
        } //for loop
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        isLoading = false;
      } //if
      swipeStatus = "";
    }); // setState
  } // getData

// メイン画面を作成
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: appBar(context),
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

                              // LIKEの文字表示
                              if (cardStatuses[index].swipeStatus == "LIKE")
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "LIKE",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              // NOPEの文字表示
                              if (cardStatuses[index].swipeStatus == "NOPE")
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.red, width: 2), // 赤色の枠
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "NOPE",
                                      style: TextStyle(
                                        color: Colors.red, // お好みの色に調整
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },

                        // スワイプした時の処理
                        onStackFinished: stackFinished,
                        itemChanged: (SwipeItem item, int index) {
                          setState(() {
                            swipeStatus = "";
                            cardStatuses[index].swipeStatus = "";
                          });
                        },
                        fillSpace: true,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      floatingActionButton: likedButton(), // いいねボタン（LIKE or NOPE）
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //ボタンの位置
    );
  }

// ボトムナビゲーションバーを作成
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
                      child: Container(), // Badgeがない時にも空のコンテナを置いておくとレイアウトが崩れない
                      badgeColor: Colors.pink,
                    ),
                  ),
                ],
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
    );
  }

// いいねボタン（LIKE or NOPE）を作成
  Row likedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'nope',
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              swipeStatus = "NOPE";
              _matchEngine!.currentItem?.nope();
            });
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
        FloatingActionButton(
          heroTag: 'like',
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              swipeStatus = "LIKE";
              _matchEngine!.currentItem?.like();
            });
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

  void stackFinished() {
    setState(() {
      // データリストのインデックスをリセット
      currentMediaIndices = List.filled(usersData.length, 0);
      currentImageIndices = List.filled(usersData.length, 0);
      currentVideoIndices = List.filled(usersData.length, 0);

      // SwipeItemsをリセットして再構築
      _swipeItems.clear();
      for (int i = 0; i < usersData.length; i++) {
        _swipeItems.add(SwipeItem(
          content: Content(text: usersData[i]['name']),
        ));
      }

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
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
                      usersData[index]['name'] +
                          ", " +
                          usersData[index]['age'].toString(),
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
                      usersData[index]['city'] +
                          ", " +
                          usersData[index]['country'],
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
                      builder: (context) => UserShow(
                        name: usersData[index]['name'],
                        age: usersData[index]['age'].toString(),
                        gender: usersData[index]['gender'],
                        city: usersData[index]['city'],
                        state: usersData[index]['state'],
                        country: usersData[index]['country'],
                        phone: usersData[index]['phone'].toString(),
                        email: usersData[index]['email'],
                        avatar: usersData[index]['pictures'],
                        video: usersData[index]['videos'],
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

// 画像の影を作成
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
    var user = usersData[index];
    var currentMediaIndex = currentMediaIndices[index];
    var totalMediaCount = user['pictures'].length + user['videos'].length;
    var currentPictureIndex = currentImageIndices[index];
    var currentVideoIndex = currentVideoIndices[index];

    Widget displayMedia;
    if (currentMediaIndex < user['pictures'].length) {
      displayMedia = Image.asset(
        user['pictures'][currentPictureIndex],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      displayMedia = VideoDisplay(videoUrl: user['videos'][currentVideoIndex]);
    }

    return Card(
      child: GestureDetector(
        onTap: () => nextMedia(index),
        child: Stack(
          children: [
            displayMedia,
            // インジケーターの表示
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(totalMediaCount, (indicatorIndex) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: currentMediaIndex == indicatorIndex
                              ? Colors.white
                              : Colors.black.withOpacity(0.5),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
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
    );
  }
}

class VideoDisplay extends StatefulWidget {
  final String videoUrl;

  const VideoDisplay({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoController.setVolume(0.0);
          _isPlayerInitialized = true;
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: true,
            looping: true,
            showControls: false,
          );
        });
      }).catchError((error) {
        print('Video player initialization error: $error');
        setState(() {
          _isPlayerInitialized = false;
        });
      });
  }

  @override
  void didUpdateWidget(VideoDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _videoController.dispose();
      _initializeVideoPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isPlayerInitialized
        ? Chewie(controller: _chewieController!)
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
