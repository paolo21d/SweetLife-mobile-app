import 'dart:convert';

class RecipeComment {
  final String content;
  final DateTime auditCD;
  final String userLogin;

  RecipeComment(this.content, this.auditCD, this.userLogin);

  String toJson() {
    return json.encode({
      "content": this.content,
      "auditCD": this.auditCD.toIso8601String(),
      "userLogin": this.userLogin
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "content": this.content,
      "auditCD": this.auditCD.toIso8601String(),
      "userLogin": this.userLogin
    };
  }
}
