class ProductModel {
  final int idProduct;
  final String name;

  ProductModel({
    required this.idProduct,
    required this.name,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduct: json["id_product"],
      name: json["name"],
    );
  }

  static List<ProductModel> fromJsonList(List list) {
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$idProduct $name';
  }

  /// Check equality of two models
  bool isEqual(ProductModel model) {
    return idProduct == model.idProduct;
  }

  @override
  String toString() => name;
}
