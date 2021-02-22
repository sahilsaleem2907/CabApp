import 'package:firebase_database/firebase_database.dart';

class UserModelFile{
  String fullName;
  String email;
  String phone;
  String id;

  UserModelFile({
    this.email,
    this.fullName,
    this.phone,
    this.id,
  });

  UserModelFile.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
  }

}