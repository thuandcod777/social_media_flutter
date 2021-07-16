class Register {
  String username;

  String password;
  String email;
  String country;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;

    return data;
  }
}
