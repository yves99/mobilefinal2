import 'package:flutter/material.dart';
import '../models/user.dart';

class registerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return registerScreenState();
  }
}

class registerScreenState extends State<registerScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

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

  void deleteUsers() {
    userProvider.deleteUsers().then((r) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: userid,
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value.isEmpty) return "User Id is required";
                  if (value.length < 6 || value.length > 12)
                    return "User Id ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร";
                },
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Suthathip Srikosapala",
                  icon: Icon(Icons.person_pin),
                ),
                validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "Name is required";
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
              TextFormField(
                controller: age,
                decoration: InputDecoration(
                  labelText: "Age",
                  icon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Age is required";
                  if (!isNumeric(value)) return "กรุณาระบุอายุ";
                  if (int.parse(value) < 10 || int.parse(value) > 80)
                    return "Age ต้องอยู่ในช่วง 10-80 ปี";
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
                  if (value.isEmpty || value.length < 6)
                    return "Password is required";
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        child: Text("REGISTER NEW ACCOUNT"),
                        onPressed: () {
                          bool checker = true;
                          if (_formkey.currentState.validate()) {
                            if (currentUsers.length == 0) {
                             //เช็คว่าฐานข้อมูลมีข้อมูลไหม ถ้าไม่ มันจะใส่ปกติ
                              Account account = Account(
                                  userid: userid.text,
                                  name: name.text,
                                  age: age.text,
                                  password: password.text);
                              userProvider.insert(account).then((r) {
                                Navigator.pushNamed(context, '/');
                              });
                            } else {
                              //วนลูปฐาน แล้วเช็คว่าuser ตรงไหม
                              for (int i = 0; i < currentUsers.length; i++) {
                                if (userid.text == currentUsers[i].userid) {
                                  checker = false;
                                  break;
                                }
                              }
                              if (checker) {
                                //checker==true เอาเข้าฐาน
                                Account account = Account(
                                    userid: userid.text,
                                    name: name.text,
                                    age: age.text,
                                    password: password.text);
                                userProvider.insert(account).then((r) {
                                  Navigator.pushNamed(context, '/');
                                });
                              } else {
                                //มันซ้ำ เปลี่ยนchecker เป็น false แล้ว มันจะ เกิดเอ๋อ
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            'ผู้ใช้นี้มีในระบบแล้ว'),
                                      );
                                    });
                              }
                            }
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
      ),
    );
  }
}
