/// jacokwu
/// 8/25/21 3:41 PM

/// 标签
class CategoryModel {
  late String categoryName;
  late String id;
  late List<SubCate>? subCate;

  CategoryModel({required this.categoryName, required this.id, this.subCate});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    id = json['id'];
    if (json['subCate'] != null) {
      subCate = [];
      json['subCate'].forEach((v) {
        subCate!.add(new SubCate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['id'] = this.id;
    if (this.subCate != null) {
      data['subCate'] = this.subCate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCate {
  late String categoryName;
  late String id;
  late int count;

  SubCate({required this.categoryName, required this.id, required this.count});

  SubCate.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['id'] = this.id;
    data['count'] = this.count;
    return data;
  }
}
