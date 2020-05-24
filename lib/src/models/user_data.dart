class UserData {

  String id;
  String email;
  String name;

  UserData({
    this.id,
    this.email,
    this.name,
  });

  UserData.fromFirebase(Map<String, dynamic> data, uid) {
    id = uid;
    email = data['email'];
    name = data['name'];
  }

}