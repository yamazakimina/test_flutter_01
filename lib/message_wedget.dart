import 'chat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<String>> userImages;

  @override
  void initState() {
    super.initState();
    userImages = fetchUserImages(50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
          Expanded(
            child: SafeArea(
              child: MessageWedget(),
            ),
          ),
        ],
      ),
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
        Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class MessageWedget extends StatelessWidget {
  const MessageWedget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const Chat();
              }));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            leading: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: const Text('**分前'),
            title: const Text('test'),
            subtitle: const Text('sample'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            leading: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: Text('**分前'),
            title: Text('test'),
            subtitle: Text('sample'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            leading: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: Text('**分前'),
            title: Text('test'),
            subtitle: Text('sample'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            leading: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: Text('**分前'),
            title: Text('test'),
            subtitle: Text('sample'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            leading: ClipOval(
              child: Image.asset(
                'assets/img/1.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            trailing: Text('**分前'),
            title: Text('test'),
            subtitle: Text('sample'),
          ),
        ],
      ),
    );
  }
}
