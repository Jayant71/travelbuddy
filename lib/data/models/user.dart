class User {
  final String uid;
  final String name;
  final String email;
  int completedDeliveries = 0;
  int rewardPoints = 0;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.completedDeliveries = 0,
    this.rewardPoints = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      completedDeliveries: json['completedDeliveries'],
      rewardPoints: json['rewardPoints'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'completedDeliveries': completedDeliveries,
      'rewardPoints': rewardPoints,
    };
  }
}
