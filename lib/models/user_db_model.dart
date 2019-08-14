import 'package:sqflite_login/models/db_model.dart';
import 'package:sqflite_login/services/user_db_services.dart';
import 'package:scoped_model/scoped_model.dart';

class DatabaseService extends Model{
  Future<List<User>> future;
  DatabaseCreator con = new DatabaseCreator();
  String fullName, password, email, phoneNo, icPassport;
  int id;
  
  static Future<List<User>> getAllUsers() async {
    await DatabaseCreator().initDatabase();
    final sql = '''SELECT * FROM ${DatabaseCreator.userTable} WHERE ${DatabaseCreator.isDeleted} = 0''';
    final data = await db.rawQuery(sql);
    List<User> users = List();

    for (final node in data) {
      final user = User.fromJson(node);
      users.add(user);
    }
    return users;
  }

  static Future<User> getUser(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.userTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final user = User.fromJson(data.first);
    return user;
  }

  static Future<User> getLogin(String name, String pass) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.userTable}
    WHERE ${DatabaseCreator.fullName} = '$name'
    AND ${DatabaseCreator.password} = '$pass'
    ''';

    List<dynamic> params = [name,pass];
    final data = await db.rawQuery(sql, params);

    final user = User.fromJson(data.first);
    return user;
  }

  static Future<void> addUser(User user) async {
    final sql = '''INSERT INTO ${DatabaseCreator.userTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.fullName},
      ${DatabaseCreator.password},
      ${DatabaseCreator.email},
      ${DatabaseCreator.phoneNo},
      ${DatabaseCreator.icPassport},
      ${DatabaseCreator.isDeleted}
    )
    VALUES (?,?,?,?,?,?,?)''';
    List<dynamic> params = [user.id, user.fullName, user.password, user.email, user.phoneNo, user.icPassport, user.isDeleted ? 1 : 0];
    print(params);
    final result = await db.rawInsert(sql, params);
    print(result);

    DatabaseCreator.databaseLog('Add user', sql, null, result, params);
  }

  static Future<void> deleteUser(User user) async {
    final sql = '''UPDATE ${DatabaseCreator.userTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [user.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete user', sql, null, result, params);
  }

  static Future<void> updateUser(User user) async {
    final sql = '''UPDATE ${DatabaseCreator.userTable}
    SET ${DatabaseCreator.fullName} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [user.fullName, user.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update user', sql, null, result, params);
  }

  static Future<int> todosCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.userTable}''');
    print('dalam todosCount');
    print(data);

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  void readData() async {
    final user = await DatabaseService.getUser(id);
    print(user.fullName);
    print(user.password);
    print(user.email);
    print(user.phoneNo);
    print(user.icPassport);
  }

  updateData(User user) async {
    user.fullName = 'please 🤫';
    await DatabaseService.updateUser(user);
    future = DatabaseService.getAllUsers();
  }

  deleteData(User user) async {
    await DatabaseService.deleteUser(user);
    id = null;
    future = DatabaseService.getAllUsers();
  }
}