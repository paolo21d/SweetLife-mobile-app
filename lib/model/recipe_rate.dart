import 'dart:convert';

class RecipeRate {
  final double rate;
  final DateTime auditCD;
  final String userLogin;

  RecipeRate(this.rate, this.auditCD, this.userLogin);

  String toJson() {
    return json.encode({
      "rate": this.rate,
      "auditCD": this.auditCD.toIso8601String(),
      "userLogin": this.userLogin
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "rate": this.rate,
      "auditCD": this.auditCD.toIso8601String(),
      "userLogin": this.userLogin
    };
  }
}
