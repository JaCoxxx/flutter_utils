
/// 解析get传递的参数
Map<String, dynamic> getParametersDecode(String parameters) {
  Map<String, dynamic> parametersMap = {};
  parameters.split('?')[1].split('&').forEach((element) {
    List keyValue = element.split('=');
    parametersMap[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
  });
  return parametersMap;
}
