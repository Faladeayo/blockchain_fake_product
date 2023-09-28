List<MyFile> myfilesFromJson(dynamic str) => List<MyFile>.from(
      (str).map(
        (e) => MyFile.fromJson(e),
      ),
    );

List<User> usersFromJson(dynamic str) => List<User>.from(
      (str).map(
        (e) => User.fromJson(e),
      ),
    );

class MyFile {
  String? sId;
  String? name;
  String? price;
  String? description;
  List<Users>? users;
  int? iV;

  MyFile(
      {this.sId, this.name, this.description, this.users, this.iV, this.price});

  MyFile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Users {
  User? user;
  String? sId;

  Users({this.user, this.sId});

  Users.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? userId;

  User({this.name, this.email, this.createdAt, this.updatedAt, this.userId});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }
}
