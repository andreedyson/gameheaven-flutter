class BrandModel {
  final String idBrand;
  final String name;

  BrandModel({
    required this.idBrand,
    required this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      idBrand: json["id_brand"],
      name: json["name"],
    );
  }

  static List<BrandModel> fromJsonList(List list) {
    return list.map((item) => BrandModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$idBrand $name';
  }

  /// Check equality of two models
  bool isEqual(BrandModel model) {
    return idBrand == model.idBrand;
  }

  @override
  String toString() => name;
}
