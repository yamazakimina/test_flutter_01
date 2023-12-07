import 'chat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.forum),
            color: Colors.black87,
          ),
        ],
        centerTitle: true,
      ),
      body: const SafeArea(
        child: MessageWedget(),
      ),
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
                const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
