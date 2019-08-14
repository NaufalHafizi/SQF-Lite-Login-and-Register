import 'package:sqflite_login/services/user_db_services.dart';

class User{
  int id;
  String fullName;
  String password;
  String email;
  String phoneNo;
  String icPassport;
  bool isDeleted;

  User(this.id, this.fullName, this.password, this.email, this.phoneNo, this.icPassport, this.isDeleted);

  User.fromJson(Map<String, dynamic> json){
    this.id = json[DatabaseCreator.id];
    this.fullName = json[DatabaseCreator.fullName];
    this.password = json[DatabaseCreator.password];
    this.email = json[DatabaseCreator.email];
    this.phoneNo = json[DatabaseCreator.phoneNo];
    this.icPassport = json[DatabaseCreator.icPassport];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}