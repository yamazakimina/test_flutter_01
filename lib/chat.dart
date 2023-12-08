import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Column(
                  children: <Widget>[
                    rightBalloon(),
                    leftBalloon(),
                    rightBalloon(),
                  ],
                ),
              ),
            ),
            TextInputWidget(),
          ],
        ),
      ),
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
