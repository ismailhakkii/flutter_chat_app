import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _nameController = TextEditingController();

  void _addContact() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Yeni Kişi Ekle"),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(hintText: "Kişi İsmi"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nameController.clear();
            },
            child: Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                var contactBox = Hive.box<ContactModel>('contacts');
                var contact = ContactModel(
                  id: Uuid().v4(),
                  name: _nameController.text,
                );
                contactBox.add(contact);
                setState(() {});
                Navigator.pop(context);
                _nameController.clear();
              }
            },
            child: Text("Ekle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var contactBox = Hive.box<ContactModel>('contacts');

    return Scaffold(
      appBar: AppBar(
        title: Text("Kişiler"),
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box<ContactModel> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text("Henüz kişi eklenmemiş."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              ContactModel contact = box.getAt(index)!;
              return ListTile(
                title: Text(contact.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(contact: contact),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: Icon(Icons.add),
      ),
    );
  }
}
