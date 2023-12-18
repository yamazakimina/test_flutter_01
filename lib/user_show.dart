import 'package:flutter/material.dart';

class UserShow extends StatefulWidget {
  final String name, gender, city, state, country, email, age, phone;
  final List<String> avatar, video;

  const UserShow({
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
  _UserShowState createState() => _UserShowState();
}

class _UserShowState extends State<UserShow> {
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
      appBar: AppBar(
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
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: photoDetails(widget: widget),
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
}

class photoDetails extends StatelessWidget {
  const photoDetails({
    super.key,
    required this.widget,
  });

  final UserShow widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: kToolbarHeight - 32),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Card(
                  shadowColor: Colors.grey,
                  elevation: 16.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        widget.avatar[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.black12),
                ),
              ],
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
