class RecipeComment {
  final int id;
  final DateTime auditCD;
  final int userId;
  final String userLogin;
  final int recipeId;

  RecipeComment(
      this.id, this.auditCD, this.userId, this.userLogin, this.recipeId);
}
