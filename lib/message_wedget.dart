import 'chat.dart';
import 'package:flutter/material.dart';

class MessageWedget extends StatelessWidget {
  const MessageWedget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
