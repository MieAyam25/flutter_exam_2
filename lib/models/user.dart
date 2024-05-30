// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final int id;
  final String employee_name;
  final int employee_salary;
  final int employee_age;
  final String profile_image;

  User({
    required this.id,
    required this.employee_name,
    required this.employee_salary,
    required this.employee_age,
    required this.profile_image,
    
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      employee_name: json['employee_name'], 
      employee_salary: json['employee_salary'], 
      employee_age: json['employee_age'], 
      profile_image: json['profile_image'],
    );
  }
}
