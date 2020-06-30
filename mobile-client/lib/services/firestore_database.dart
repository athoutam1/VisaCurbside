import 'package:visa_curbside/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseService {

  final CollectionReference chatCollection = Firestore.instance.collection('chats');

  Stream<List<Message>> getMessagesFroUserIDAndStoreID(String userID, String storeID) {
    return chatCollection.document('${userID}AND${storeID}').snapshots().map(_messageListFromDocumentSnapshot);
  }

  List<Message> _messageListFromDocumentSnapshot(DocumentSnapshot snapshot) {
    List<Message> messages =  new List<Message>();
    if (snapshot.data == null) {
      return messages;
    }
    snapshot.data['messages'].forEach((m) {
      messages.add(Message.fromMap(m));
    });
    return messages;
  }

}