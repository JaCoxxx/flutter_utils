/// jacokwu
/// 8/23/21 1:48 PM

class MultiSelectItem {
  late String value;
  late String label;
  late bool disabled;

  MultiSelectItem({required this.value, required this.label, this.disabled = false});

  MultiSelectItem.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
    disabled = json['disabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    data['disabled'] = this.disabled;
    return data;
  }
}
