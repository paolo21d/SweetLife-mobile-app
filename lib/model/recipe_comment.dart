class RecipeComment {
  final int id;
  final String comment;
  final DateTime auditCD;
  final int userId;
  final String userLogin;
  final int recipeId;

  RecipeComment(this.id, this.comment, this.auditCD, this.userId,
      this.userLogin, this.recipeId);
}
