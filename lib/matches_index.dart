import 'chat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

Future<List<Map<String, String>>> fetchUserData(int count) async {
  final response =
      await http.get(Uri.parse('https://randomuser.me/api/?results=$count'));

  if (response.statusCode == 200) {
    List<Map<String, String>> userData = [];
    var data = json.decode(response.body);
    for (var user in data['results']) {
      userData.add({
        'imageUrl': user['picture']['medium'],
        'firstName': user['name']['first'],
      });
    }
    return userData;
  } else {
    throw Exception('Failed to load user data');
  }
}

class ImageOnlyMatch extends StatelessWidget {
  final String imageUrl;

  const ImageOnlyMatch({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10), // 右のスペースを調整
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MatchesIndex extends StatefulWidget {
  const MatchesIndex({Key? key}) : super(key: key);

  @override
  _MatchesIndexState createState() => _MatchesIndexState();
}

class _MatchesIndexState extends State<MatchesIndex> {
  late Future<List<Map<String, String>>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData(50);
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
          FutureBuilder<List<Map<String, String>>>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // 画像のみを表示
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!
                        .map((user) =>
                            ImageOnlyMatch(imageUrl: user['imageUrl']!))
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
            child: FutureBuilder<List<Map<String, String>>>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return MessageWidget(userData: snapshot.data!);
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
  final String firstName;

  const ImagesMatch({
    Key? key,
    required this.imageUrl,
    required this.firstName,
  }) : super(key: key);

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
        Text(firstName),
        const SizedBox(width: 10),
      ],
    );
  }
}

class MessageWidget extends StatelessWidget {
  final List<Map<String, String>> userData;

  const MessageWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          var user = userData[index];
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
                userData[index]['imageUrl']!,
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
            title: Text(user['firstName'] ?? 'Unknown'),
            subtitle: const Text('sample'),
          );
        },
      ),
    );
  }
}
