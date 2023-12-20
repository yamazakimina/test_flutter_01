import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// データ取得
class UserGraphicsShow extends StatefulWidget {
  final String name, gender, city, state, country, email, age, phone;
  final List<String> avatar, video;
  List<String> get mediaList => [...avatar, ...video];

  const UserGraphicsShow({
    Key? key,
    required this.name,
    required this.age,
    required this.gender,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.video,
  }) : super(key: key);

  @override
  _UserGraphicsShowState createState() => _UserGraphicsShowState();
}

class _UserGraphicsShowState extends State<UserGraphicsShow> {
  int currentMediaIndex = 0;
  final PageController _pageController = PageController();

  void _nextMedia() {
    setState(() {
      currentMediaIndex = (currentMediaIndex + 1) % widget.mediaList.length;
    });
  }

// コントローラを破棄
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

// 描画
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(children: [
        GestureDetector(
          onTap: _nextMedia,
          child: SingleChildScrollView(
            child: photoDetails(
                widget: widget, currentMediaIndex: currentMediaIndex),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: buttonLikes(),
        ),
      ]),
    );
  }

// AppBar
  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: .6,
      title: Container(
        margin: const EdgeInsets.all(0.0),
        child: Text(
          widget.name + ", " + widget.age,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: true,
    );
  }
}

// メイン：写真と動画と詳細プロフィール
class photoDetails extends StatelessWidget {
  const photoDetails({
    super.key,
    required this.widget,
    required this.currentMediaIndex,
  });

  final UserGraphicsShow widget;
  final int currentMediaIndex;

  @override
  Widget build(BuildContext context) {
    int totalMediaCount = widget.mediaList.length;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                MediaDisplay(mediaPath: widget.mediaList[currentMediaIndex]),
                // インジケータを追加
                indicator(totalMediaCount),
              ],
            ),
          ),
          // 他の contentsDetails ウィジェット
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
        ],
      ),
    );
  }

  Positioned indicator(int totalMediaCount) {
    return Positioned(
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
    );
  }
}

// 画像と動画の切り替え
class MediaDisplay extends StatelessWidget {
  final String mediaPath;

  const MediaDisplay({Key? key, required this.mediaPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      // 画像の場合
      return Image.asset(mediaPath, fit: BoxFit.cover);
    } else {
      // ビデオの場合
      final videoPlayerController = VideoPlayerController.asset(mediaPath);
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: false,
      );
      return Chewie(controller: chewieController);
    }
  }
}

// ボタン：いいねとスキップ
class buttonLikes extends StatelessWidget {
  const buttonLikes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'nope',
            backgroundColor: Colors.white,
            onPressed: () {
              // _matchEngine!.currentItem?.nope();
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
              // _matchEngine!.currentItem?.like();
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
      ),
    );
  }
}

// プロフィール詳細
class contentsDetails extends StatelessWidget {
  const contentsDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
        height: 120,
        child: Card(
          color: Colors.white,
          shadowColor: Colors.grey,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.search, // 検索アイコン
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    const Text('求めるものは',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.local_drink,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8), // アイコンとテキストの間にスペースを追加
                        Text(
                          '飲み友達が欲しい',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
