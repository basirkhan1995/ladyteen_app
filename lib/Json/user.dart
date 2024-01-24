

class Users{
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final int? usrRole;
  final String? fullName;
  final int? roleNumber;
  final String? roleName;
  final String? phone;
  final String? jobTitle;
  final String? bankAccName;
  final String? cardNumber;
  final int? status;
  final String? accCreatedAt;
  final String? accTypeName;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    this.usrRole,
    this.roleName,
    this.fullName,
    this.roleNumber,
    this.phone,
    this.jobTitle,
    this.bankAccName,
    this.cardNumber,
    this.status,
    this.accCreatedAt,
    this.accTypeName,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json['usrId'],
    usrName: json ['usrName'],
    usrPassword: json['usrPassword'],
    fullName: json['fullName'],
    roleNumber: json['roleNumber'],
    roleName:json['roleName'],
    phone: json['phone'],
    jobTitle: json['jobTitle'],
    bankAccName: json['bankAccName'],
    cardNumber: json['bankCardNo'],
    status: json['usrStatus'],
    accCreatedAt: json['accCreatedAt'],
    accTypeName: json['accTypeName'],

  );

  Map<String, dynamic> toMap(){
    return{
      'usrId':usrId,
      'usrName':usrName,
      'usrPassword':usrPassword,
      'fullName' :fullName,
      'roleNumber': roleNumber,
      'roleName': roleName,
      'phone':phone,
      'jobTitle':jobTitle,
      'bankAccName':bankAccName,
      'bankCardNo' :cardNumber,
      'usrStatus':status,
      'accCreatedAt':accCreatedAt,
      'accTypeName':accTypeName
    };
  }

}