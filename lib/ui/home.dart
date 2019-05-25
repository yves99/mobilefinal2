import 'package:flutter/material.dart';
import '../models/user.dart';
import './profile.dart';
import './friend.dart';

class homeScreen extends StatefulWidget {
  final Account account;
  homeScreen({Key key, this.account}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return homeScreenState();
  }
}

class homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Hello ${account.name}',
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text('this is my quote  "${account.quote}"'),
                ),
                RaisedButton(
                  child: Text("PROFILE SETUP"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profileScreen(account: account),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("MY FRIENDS"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => friendScreen(account: account),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("SIGN OUT"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
