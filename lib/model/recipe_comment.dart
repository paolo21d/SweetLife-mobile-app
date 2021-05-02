class RecipeComment {
  final int id;
  final String content;
  final DateTime auditCD;
  final int userId;
  final String userLogin;
  final int recipeId;

  RecipeComment(this.id, this.content, this.auditCD, this.userId,
      this.userLogin, this.recipeId);
}
