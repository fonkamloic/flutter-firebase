import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DatabaseService databaseService = DatabaseService(uid: user.uid);
    return StreamBuilder<UserData>(
      stream: databaseService.userData,
      builder: (context, snapshot) => !snapshot.hasData
          ? Loading()
          : Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update you brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: snapshot.data.name),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),

                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? snapshot.data.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugar(s)'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),

                  // slider
                  Slider(
                    value:
                        (_currentStrength ?? snapshot.data.strength).toDouble(),
                    min: 100,
                    activeColor: Colors
                        .brown[_currentStrength ?? snapshot.data.strength],
                    inactiveColor: Colors
                        .brown[_currentStrength ?? snapshot.data.strength],
                    max: 900,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),

                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await databaseService.updateUserData(
                            _currentSugars ?? snapshot.data.sugars,
                            _currentName ?? snapshot.data.name,
                            _currentStrength ?? snapshot.data.strength);
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
