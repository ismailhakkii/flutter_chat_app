import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'models/contact.dart';
import 'models/message.dart';
import 'screens/registration_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ContactModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<ContactModel>('contacts');
  await Hive.openBox<MessageModel>('messages');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Simple Chat App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: RegistrationScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  UserModel? currentUser;

  void setUser(UserModel user) {
    currentUser = user;
    notifyListeners();
  }
}
