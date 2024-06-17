class User{
  String userid;
  String password;

  User(
      this.userid,
      this.password,
      );


  toJson()
  {
    return {
      'userid' : userid,
      'password' : password
    };
  }
}