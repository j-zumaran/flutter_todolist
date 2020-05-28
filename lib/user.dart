
class UserData {
  UserData(this.id);

  final int id;
}

class Todo {
  String name;
}

class UserTag {
  int _id;
  String name;

  UserTag(this._id, this.name);
  UserTag.name(this.name);

  Map<String, dynamic> toJson(){
    return {
      'id': _id,
      'name': name
    };
  }

  factory UserTag.fromJson(Map<dynamic, dynamic> json) {
    return UserTag(json['id'], json['name']);
  }
}