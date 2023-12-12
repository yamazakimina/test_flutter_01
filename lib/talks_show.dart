import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TalksShow extends StatelessWidget {
  final String firstName; // ユーザーのファーストネーム
  final String imageUrl; // ユーザーの画像URL

  const TalksShow({Key? key, required this.firstName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                children: <Widget>[
                  rightBalloon(),
                  leftBalloon(),
                  rightBalloon(),
                  photo(),
                  VideoDisplay(),
                  leftBalloon(),
                  LeftPhoto(), // 左寄せ写真を追加
                  LeftVideoDisplay(), // 左寄せビデオを追加
                ],
              ),
            ),
            TextInputWidget(),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: .6,
      toolbarHeight: 80, // AppBarの高さを調整
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              imageUrl, // 画像URLを使用
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            firstName, // ファーストネームを表示
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      // actions: <Widget>[
      //   IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.video_call),
      //     color: Colors.grey,
      //     iconSize: 36,
      //   ),
      // ],
      centerTitle: true,
    );
  }

  Padding leftBalloon() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 233, 233),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text('いや、いきなり無理でしょ'),
          ),
        ],
      ),
    );
  }

  // 修正: TextInputWidgetメソッドを追加
  Container TextInputWidget() {
    return Container(
      height: 68,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              // 修正: EdgeInsets.allをEdgeInsets.onlyに変更
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: TextField(
                  keyboardType: TextInputType.multiline, //複数行のテキスト入力
                  maxLines: 5,
                  minLines: 1,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'メッセージを入力',
                    hintStyle:
                        TextStyle(color: Colors.grey), // テキストを薄く表示させるスタイル
                  ),
                ),
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.mic),
          //   iconSize: 28,
          //   color: Colors.black54,
          //   onPressed: () {},
          // ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class rightBalloon extends StatelessWidget {
  const rightBalloon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            'こんにちは。今日の夜会えますか？',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class photo extends StatelessWidget {
  const photo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Image.asset(
          'assets/img/1.jpg',
          width: 250,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class VideoDisplay extends StatefulWidget {
  const VideoDisplay({Key? key}) : super(key: key);

  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _controller.pause();
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller),
        ));
        _controller.play();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 250,
            height: 150,
            child: _controller.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      if (!_isPlaying)
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 50.0,
                        ),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.controller,
      aspectRatio: widget.controller.value.aspectRatio,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }
}

class LeftPhoto extends StatelessWidget {
  const LeftPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/1.jpg', // 画像パスを適切に設定
          width: 250,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LeftVideoDisplay extends StatefulWidget {
  const LeftVideoDisplay({Key? key}) : super(key: key);

  @override
  _LeftVideoDisplayState createState() => _LeftVideoDisplayState();
}

class _LeftVideoDisplayState extends State<LeftVideoDisplay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _controller.pause();
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller),
        ));
        _controller.play();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.centerLeft, // 左寄せに変更
          child: Container(
            width: 250,
            height: 150,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Container(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
