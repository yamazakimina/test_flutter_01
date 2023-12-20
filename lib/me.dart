import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'matches_index.dart';

class Me extends StatefulWidget {
  final String name, gender, city, state, country, email, age, phone;
  final List<String> avatar, video;

  const Me({
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
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  int currentMediaIndex = 0;

  void nextMedia() {
    setState(() {
      int totalMediaCount = widget.avatar.length + widget.video.length;
      currentMediaIndex = (currentMediaIndex + 1) % totalMediaCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(children: [
        SingleChildScrollView(
          child: photoDetails(widget: widget),
        ),
      ]),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}

class photoDetails extends StatelessWidget {
  const photoDetails({
    super.key,
    required this.widget,
  });

  final Me widget;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.5;
    return Container(
      // margin: const EdgeInsets.only(top: kToolbarHeight - 32),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: imageSize,
              width: screenWidth,
              child: Center(
                child: SizedBox(
                  height: imageSize,
                  width: imageSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(
                              widget.avatar[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).canvasColor,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // 編集ページへのナビゲーションをここに追加
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${widget.name}, ${widget.age}', // 名前と年齢を表示
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
          contentsDetails(),
        ],
      ),
    );
  }
}

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 左側のコンテンツ（アイコンとテキストを縦に配置）
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.search, // 検索アイコン
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '求めるものは',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.local_drink,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8), // アイコンとテキストの間にスペースを追加
                        const Text(
                          '飲み友達が欲しい',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

AppBar appBar(BuildContext context) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Theme.of(context).canvasColor,
    toolbarHeight: 72.0,
    titleSpacing: 20,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.settings, color: Colors.grey),
        onPressed: () {
          // ここに歯車アイコンをタップした時の処理を追加
        },
      ),
    ],
  );
}
