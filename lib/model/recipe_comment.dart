class RecipeComment {
  final int id;
  final double rate;
  final DateTime auditCD;
  final int userId;
  final int recipeId;

  RecipeComment(this.id, this.rate, this.auditCD, this.userId, this.recipeId);
}
