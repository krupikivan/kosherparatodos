class Cliente{

  String email;
  String name;

  Cliente.fromMap(Map<String, dynamic> data){
    email = data['email'];
    name = data['name'];
  }
}