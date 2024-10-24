import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String contactId;

  @HiveField(2)
  String senderId;

  @HiveField(3)
  String content;

  @HiveField(4)
  DateTime timestamp;

  MessageModel({
    required this.id,
    required this.contactId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}
