import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 1)
class ContactModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  ContactModel({required this.id, required this.name});
}
