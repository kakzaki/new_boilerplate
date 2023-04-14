class User {
  String? iduser;
  String? namauser;
  String? password;
  String? email;
  String? telepon;
  String? apitoken;

  User(this.iduser, this.namauser, this.password, this.email, this.telepon,
      this.apitoken);

  User.nulls();

  static final columns = [
    "iduser",
    "namauser",
    "password",
    "email",
    "telepon",
    "apitoken"
  ];

  User.fromMap(Map map) {
    iduser = map["iduser"];
    namauser = map["namauser"];
    password = map["password"];
    email = map["email"];
    telepon = map["telepon"];
    apitoken = map["apitoken"];
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      "iduser": iduser,
      "namauser": namauser,
      "password": password,
      "email": email,
      "telepon": telepon,
      "apitoken": apitoken,
    };
    return map;
  }
}
