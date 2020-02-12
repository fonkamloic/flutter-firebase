import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :  Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text("Sign in to Brew Crew"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toogleView();
              },
              icon: Icon(Icons.person),
              label: Text("Register"))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: "Password"),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a valid password ' : null,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);

                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    },
                    color: Colors.pink[400],
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
