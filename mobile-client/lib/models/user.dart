class User {
  final String uid;
  User(this.uid);

  User.fromJson(Map<String, dynamic> json) : uid = json['uid'];

  Map<String, dynamic> toJson() => {'uid': uid};
}
