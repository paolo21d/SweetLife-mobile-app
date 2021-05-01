import 'package:SweetLife/model/unit.dart';

class Ingredient {
  final int id;
  final String name;
  final List<Unit> availableUnits;

  Ingredient(this.id, this.name, this.availableUnits);
}