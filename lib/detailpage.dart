import 'package:flutter/material.dart';
import 'dart:ui';

class DetailsPage extends StatefulWidget {
  final String name, gender, city, state, country, email, avatar, age, phone;

  const DetailsPage({
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
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
      body: Container(
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
                        child: Image.network(
                          widget.avatar,
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
            Padding(
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            spreadRadius: 1)
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 36,
                        ),
                        onPressed: () {
                          // _matchEngine!.currentItem?.nope();
                        },
                        // child: const Text("Nope"),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            spreadRadius: 1)
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32.0,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.star,
                              color: Colors.blue,
                              size: 32.0,
                            ),
                            onPressed: () {
                              // _matchEngine!.currentItem?.superLike();
                            },
                            //child: const Text("Superlike"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            spreadRadius: 1)
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.green,
                          size: 36,
                        ),
                        onPressed: () {
                          // _matchEngine!.currentItem?.like();
                        },
                        //  child: const Text("Like"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
