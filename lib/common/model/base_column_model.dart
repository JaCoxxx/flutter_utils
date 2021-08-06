/// jacokwu
/// 8/4/21 4:05 PM

class BaseColumnModel {
  late String title;
  late String key;
  String? align;
  double? width;
  double? pl;
  double? pr;
  double? pt;
  double? pb;

  BaseColumnModel({
    required this.title,
    required this.key,
    this.align,
    this.width,
    this.pl,
    this.pr,
    this.pt,
    this.pb,
  });

  BaseColumnModel.fromJson(Map<String, dynamic> json) {
    assert(json['title'] != null, 'title must not be null');
    assert(json['key'] != null, 'key must not be null');

    title = json['title'];
    key = json['key'];
    align = json['align'];
    width = json['width'];
    pl = json['pl'];
    pr = json['pr'];
    pt = json['pt'];
    pb = json['pb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['key'] = this.key;
    data['align'] = this.align;
    data['width'] = this.width;
    data['pl'] = this.pl;
    data['pr'] = this.pr;
    data['pt'] = this.pt;
    data['pb'] = this.pb;
    return data;
  }
}
