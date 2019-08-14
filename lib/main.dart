import 'package:sqflite_login/services/user_db_services.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_login/models/user_db_model.dart';
import 'package:sqflite_login/models/db_model.dart';

void main() => runApp(Signup());

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupPage(title: 'Signup Page'),
    );
  }
}

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Future<List<User>> future;
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbs = new DatabaseService();

  @override
  initState() {
    super.initState();
    future = DatabaseService.getAllUsers();
  }

  void createUser() async {
    await DatabaseCreator().initDatabase(); //call initdattabase dlm databasecreator class
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      int count = await DatabaseService.todosCount();
      print('lepas return count');
      print(count);
      final user = User(count, dbs.fullName, dbs.password, dbs.email, dbs.phoneNo, dbs.icPassport, false);
      await DatabaseService.addUser(user);
      setState(() {
        dbs.id = user.id;
        future = DatabaseService.getAllUsers();
      });
      print(user.id);
    }
  }

  Card buildItem(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${user.fullName}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'password: ${user.password}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'email: ${user.email}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Phone no: ${user.phoneNo}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'IC/Passport: ${user.icPassport}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => dbs.deleteData(user),
                  child: Text('Update todo', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => dbs.updateData(user),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildName() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Full Name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => dbs.fullName = value, // set ke fullname dlm model dbs
    );
  }

  TextFormField buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Password',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => dbs.password = value,
    );
  }

  TextFormField buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'E-mail',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => dbs.email = value,
    );
  }

  TextFormField buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Phone Number',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => dbs.phoneNo = value,
    );
  }

  TextFormField buildIcPassport() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'IC/Passport',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => dbs.icPassport = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildName(),
                buildPassword(),
                buildEmail(),
                buildPhoneNumber(),
                buildIcPassport(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createUser,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: dbs.id != null ? dbs.readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          FutureBuilder<List<User>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.map((todo) => buildItem(todo)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}