class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String dob;
  final String height;
  final String weight;
  final String sex;

  const AppUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.height,
    required this.weight,
    required this.sex,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, {required String uid}) {
    return AppUser(
      uid: uid,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      dob: data['dob'],
      height: data['height'],
      weight: data['weight'],
      sex: data['sex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'height': height,
      'weight': weight,
      'sex': sex,
    };
  }
}
