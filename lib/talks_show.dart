import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// TalkShowクラスを作成
class TalksShow extends StatefulWidget {
  final String firstName;
  final String imageUrl;

  const TalksShow({Key? key, required this.firstName, required this.imageUrl})
      : super(key: key);
  // 状態を保持するためにStateクラスを作成
  @override
  _TalksShowState createState() => _TalksShowState();
}

// Stateクラスを作成
class _TalksShowState extends State<TalksShow> {
  // メッセージを保持するためのリストを作成
  List<Widget> messages = [];
  // スクロールを制御するためのコントローラーを作成
  ScrollController _scrollController = ScrollController();

// 状態を保持するためにinitStateを使用
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    messages.addAll([
      SizedBox(height: 20),
      rightBalloon(),
      leftBalloon(widget.imageUrl),
      rightBalloon(),
      photo(),
      VideoDisplay(),
      leftBalloon(widget.imageUrl),
      LeftPhoto(),
      LeftVideoDisplay(),
    ]);
    // 画面が描画された後、一番下に移動
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToBottom();
    });
  }

// scrollControllerを解放
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

// メッセージを追加するメソッドを作成
  void sendFixedContent() {
    setState(() {
      messages.add(rightBalloon());
      messages.add(photo());
      messages.add(VideoDisplay());
    });
    // 画面が描画された後にスクロールを一番下に移動
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

// スクロールを一番下に移動するメソッドを作成
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

// 画面下に移動するメソッドを作成
  void _jumpToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

// 画面を描画
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.firstName, widget.imageUrl),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                ),
              ),
              TextInputWidget(
                onSend: sendFixedContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AppBarを作成
AppBar appBar(BuildContext context, String firstName, String imageUrl) {
  return AppBar(
    backgroundColor: Theme.of(context).canvasColor,
    elevation: .6,
    toolbarHeight: 80,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          firstName,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    ),
    centerTitle: true,
  );
}

// メッセージの左側の吹き出しを作成
Padding leftBalloon(String imageUrl) {
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

// メッセージの右側の吹き出しを作成
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

// 入力欄を作成
class TextInputWidget extends StatelessWidget {
  final VoidCallback onSend;

  TextInputWidget({Key? key, required this.onSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  autofocus: false,
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
                  onPressed: onSend,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 右の画像を表示するメソッドを作成
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

// 右のビデオを表示するメソッドを作成
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
      // タップした時にビデオを再生する
      onTap: () async {
        _controller.pause();
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller),
        ));
        _controller.play();
      },
      // ビデオが再生中かどうかを判定するフラグを作成
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
                        // 再生ボタンを表示
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

// ビデオを全画面で表示するクラスを作成
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

// 画面を描画
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

// 左の画像を表示するメソッドを作成
class LeftPhoto extends StatelessWidget {
  const LeftPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/2.jpg', // 画像パスを適切に設定
          width: 250,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// 左のビデオを表示するメソッドを作成
class LeftVideoDisplay extends StatefulWidget {
  const LeftVideoDisplay({Key? key}) : super(key: key);

  @override
  _LeftVideoDisplayState createState() => _LeftVideoDisplayState();
}

class _LeftVideoDisplayState extends State<LeftVideoDisplay> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/1.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(() {
          final isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
            setState(() {
              _isPlaying = isPlaying;
            });
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.value.isInitialized && !_controller.value.isPlaying) {
          setState(() {
            _controller.play();
            _isPlaying = true;
          });
        } else if (_controller.value.isInitialized &&
            _controller.value.isPlaying) {
          setState(() {
            _controller.pause();
            _isPlaying = false;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.centerLeft,
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
    _controller.dispose();
    super.dispose();
  }
}
