import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
            // 修正: TextInputWidgetを呼び出す
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
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic),
            iconSize: 28,
            color: Colors.black54,
            onPressed: () {},
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
