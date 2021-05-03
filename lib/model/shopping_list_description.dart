class ShoppingListDescription {
  int id;
  String name;
  DateTime auditCD;
  int elementsQuantity;
  int activeElementsQuantity;
  int auditCU;

  ShoppingListDescription(this.id, this.name, this.auditCD,
      this.elementsQuantity, this.activeElementsQuantity, this.auditCU);
}
