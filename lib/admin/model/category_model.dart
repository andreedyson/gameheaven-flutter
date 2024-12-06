class CategoryModel {
  final int idCategory;
  final String name;

  CategoryModel({
    required this.idCategory,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategory: json["id_category"],
      name: json["name"],
    );
  }

  static List<CategoryModel> fromJsonList(List list) {
    return list.map((item) => CategoryModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$idCategory $name';
  }

  /// Check equality of two models
  bool isEqual(CategoryModel model) {
    return idCategory == model.idCategory;
  }

  @override
  String toString() => name;
}
