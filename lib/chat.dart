import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

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
            child: Image.asset(
              'assets/img/1.jpg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'test',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.video_call),
          color: Colors.grey,
          iconSize: 36,
        ),
      ],
      centerTitle: true,
    );
  }

  Padding leftBalloon() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 233, 233, 233),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('いや、いきなり無理でしょ'),
            ),
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
  const rightBalloon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'こんにちは。今日の夜会えますか？',
              style: TextStyle(color: Colors.white),
            ),
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
      padding: const EdgeInsets.only(bottom: 28),
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
