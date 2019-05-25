import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../models/user.dart';
import './home.dart';


class loginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return loginScreenState();
  }
}

class loginScreenState extends State<loginScreen>{
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();
  UserProvider userProvider = UserProvider();
  List<Account> currentUsers = List();

  @override
  void initState() {
    super.initState();
    userProvider.open('userTable.db').then((r) {
      getUsers();
    });
  }

  void getUsers() {
    userProvider.getUsers().then((r) {
      setState(() {
        currentUsers = r;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Image.network(
                "http://icons.iconarchive.com/icons/webalys/kameleon.pics/256/Key-icon.png",
                height: 150,
              ),
              TextFormField(
                controller: userid,
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.perm_identity),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Username is required";
                },
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) return "Password is required";
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("LOGIN"),
                        onPressed: () {
                          bool checker = false;
                          if (_formkey.currentState.validate()) {
                            for (int i = 0; i < currentUsers.length; i++) {
                              if (userid.text == currentUsers[i].userid &&
                                  password.text == currentUsers[i].password) {
                                checker = true;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        homeScreen(account: currentUsers[i]),
                                  ),
                                );
                              }
                            }
                            if (!checker) {
                              Toast.show("Invalid user or password", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Register New Account"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
