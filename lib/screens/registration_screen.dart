import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../screens/contacts_screen.dart';
import '../main.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      var userBox = Hive.box<UserModel>('users');
      var user = UserModel(
        id: Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
      );
      userBox.add(user);

      Provider.of<AppState>(context, listen: false).setUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ContactsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kayıt Ol")),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "İsim"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İsim giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Geçerli bir email giriniz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _register, child: Text("Kayıt Ol")),
              ],
            ),
          ),
        ));
  }
}
