import 'package:flutter/material.dart';
import '../models/user.dart';
import '../ui/home.dart';

class profileScreen extends StatefulWidget {
  final Account account;
  profileScreen({Key key, this.account}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return profileScreenState();
  }
}

class profileScreenState extends State<profileScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController quote = TextEditingController();
  UserProvider userProvider = UserProvider();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  void initState() {
    super.initState();
    userProvider.open('userTable.db').then((r) {
      print("success");
    });
  }

  @override
  Widget build(BuildContext context) {
    Account myself = widget.account;
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: userid,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)
                        ),
                        labelText: "User Id"
                      ),
                    validator: (value) {
                      if (value.length < 6 || value.length > 12)
                        return "User Id ต้องมีความยาว 6-12 ตัวอักษร";
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)
                      ),
                      labelText: "Name",
                      hintText: "Suthathip Srikosapala",
                    ),
                    validator: (value) {
                      int count = 0;
                      for (int i = 0; i < value.length; i++) {
                        if (value[i] == " ") {
                          count = 1;
                        }
                      }
                      if (count == 0) {
                        return "กรุณาระบุชื่อและนามสกุล";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: age,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)
                        ),
                      labelText: "Age",
                    ),
                    validator: (value) {
                      if (value.isEmpty) return "กรุณาระบุอายุ";
                      if (!isNumeric(value)) return "กรุณาระบุอายุ";
                      if (int.parse(value) < 10 || int.parse(value) > 80)
                        return "Age ต้องอยู่ในช่วง 10-80 ปี";
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)
                        ),
                      labelText: "Password",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 6) return "Password ต้องมีความยาวมากกว่า 6 ตัวอักษร";
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: quote,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)
                        ),
                      labelText: "Quote"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              if (userid.text != Null) {
                                myself.userid = userid.text;
                              }
                              if (name != Null) {
                                myself.name = name.text;
                              }
                              if (age.text != Null) {
                                myself.age = age.text;
                              }
                              if (password.text != Null) {
                                myself.password = password.text;
                              }
                              if (quote.text != Null) {
                                myself.quote = quote.text;
                              }
                              userProvider.updateUser(myself).then((r) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        homeScreen(account: myself),
                                  ),
                                );
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
