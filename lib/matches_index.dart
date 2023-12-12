import 'chat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

Future<List<String>> fetchUserImages(int count) async {
  final response =
      await http.get(Uri.parse('https://randomuser.me/api/?results=$count'));

  if (response.statusCode == 200) {
    List<String> imageUrls = [];
    var data = json.decode(response.body);
    for (var user in data['results']) {
      imageUrls.add(user['picture']['medium']);
    }
    return imageUrls;
  } else {
    throw Exception('Failed to load user images');
  }
}

class MatchesIndex extends StatefulWidget {
  const MatchesIndex({Key? key}) : super(key: key);

  @override
  _MatchesIndexState createState() => _MatchesIndexState();
}

class _MatchesIndexState extends State<MatchesIndex> {
  late Future<List<String>> userImages;

  @override
  void initState() {
    super.initState();
    userImages = fetchUserImages(50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              '新しいマッチ',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: userImages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // 画像を表示
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!
                        .map((imageUrl) => ImagesMatch(imageUrl: imageUrl))
                        .toList(),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              'メッセージ',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: userImages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return MessageWidget(imageUrls: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: .6,
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.forum),
          color: Colors.grey,
        ),
      ],
      centerTitle: true,
    );
  }
}

class ImagesMatch extends StatelessWidget {
  final String imageUrl;

  const ImagesMatch({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class MessageWidget extends StatelessWidget {
  final List<String> imageUrls;

  const MessageWidget({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Chat();
                }),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: ClipOval(
              child: Image.network(
                imageUrls[index],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min, // コンテンツに合わせてサイズを調整
              children: [
                const Text('**分前'), // 元々のテキスト
                badges.Badge(
                  badgeContent: Text(''), // バッジの内容
                  badgeColor: Colors.pink, // バッジの色
                ),
              ],
            ),
            title: const Text('test'),
            subtitle: const Text('sample'),
          );
        },
      ),
    );
  }
}
