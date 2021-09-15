import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_form/custom_date_form_field.dart';
import 'package:flutter_utils/widget/custom_form/custom_form_controller.dart';
import 'package:flutter_utils/widget/custom_form/custom_form_field_type.dart';
import 'package:flutter_utils/widget/custom_form/custom_select_form_field.dart';
import 'package:flutter_utils/widget/custom_form/custom_text_form_field.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/24/21 9:38 AM

class CustomFormWidget extends StatefulWidget {
  final List<Map<String, dynamic>> formField;

  final Map<String, dynamic> model;

  final ScrollController? scrollController;

  final ScrollPhysics? physics;

  final Widget separatorWidget;

  final bool readOnly;

  final Color? backgroundColor;

  final bool Function()? customCheck;

  final CustomFormController? controller;

  const CustomFormWidget({
    Key? key,
    required this.formField,
    required this.model,
    this.controller,
    this.physics,
    this.separatorWidget = emptyWidget,
    this.readOnly = false,
    this.backgroundColor,
    this.customCheck,
    this.scrollController,
  }) : super(key: key);

  @override
  _CustomFormWidgetState createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget> {

  @override
  void initState() {
    super.initState();
    _bindController();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.dispose();
    widget.scrollController?.dispose();
  }

  void _bindController() {
    // 绑定控制器
    widget.controller?.canSubmit = () => _checkRequired() && (widget.customCheck == null ? true : widget.customCheck!());
  }

  bool _checkRequired() {
    bool _hasError = false;
    widget.formField.forEach((element) {
      if (element['required'] == true) {
        dynamic value = widget.model[element['id']];
        if (value == null) {
          _hasError = true;
        } else if (value is String) {
          _hasError = isStringEmpty(value);
        } else if (value is List || value is Map) {
          _hasError = value.isEmpty;
        }
      }
    });
    return !_hasError;
  }

  bool get canSubmit => _checkRequired() && (widget.customCheck == null ? true : widget.customCheck!());

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.separated(
        itemBuilder: (_, index) => _buildFormItem(widget.formField[index]),
        separatorBuilder: (_, index) => widget.separatorWidget,
        itemCount: widget.formField.length,
        shrinkWrap: true,
        controller: widget.scrollController,
        physics: widget.physics,
      ),
    );
  }

  Widget _buildFormItem(Map<String, dynamic> item) {
    switch (item['type']) {
      case CustomFormFieldType.text:
        return CustomTextFormField(
          controller: TextEditingController()..text = widget.model[item['id']] ?? '',
          model: widget.model,
          id: item['id'],
          label: item['label'],
          isNum: item['isNum'] ?? false,
          isPhone: item['isPhone'] ?? false,
          isPositiveInteger: item['isPositiveInteger'] ?? false,
          required: item['required'] ?? false,
          readOnly: widget.readOnly || (item['readOnly'] ?? false),
          maxNum: item['maxNum'],
          minNum: item['minNum'],
          onChanged: item['onChanged'],
          placeholder: item['placeholder'],
          inputFormatters: item['inputFormatters'],
          padding: item['padding'] ?? EdgeInsets.zero,
          backgroundColor: widget.backgroundColor ?? item['backgroundColor'],
          decoration: item['decoration'],
          height: item['height'],
        );
      case CustomFormFieldType.date:
        return CustomDateFormField(
          model: widget.model,
          id: item['id'],
          endId: item['endId'],
          label: item['label'],
          required: item['required'] ?? false,
          readOnly: widget.readOnly || (item['readOnly'] ?? false),
          placeholder: item['placeholder'],
          padding: item['padding'] ?? EdgeInsets.zero,
          backgroundColor: widget.backgroundColor ?? item['backgroundColor'],
          decoration: item['decoration'],
          selectionMode: item['selectionMode'],
          onCancel: item['onCancel'],
          onSubmit: item['onSubmit'],
          joinCode: item['joinCode'],
        );
      case CustomFormFieldType.select:
        return CustomSelectFormField(
          model: widget.model,
          id: item['id'],
          label: item['label'],
          options: item['options'] ?? [],
          required: item['required'] ?? false,
          readOnly: widget.readOnly || (item['readOnly'] ?? false),
          placeholder: item['placeholder'],
          padding: item['padding'] ?? EdgeInsets.zero,
          backgroundColor: widget.backgroundColor ?? item['backgroundColor'],
          decoration: item['decoration'],
          height: item['height'],
          onRefresh: item['onRefresh'],
          onLoad: item['onLoad'],
          isSingle: item['isSingle'] ?? false,
          searchable: item['searchable'] ?? false,
          searchHint: item['searchHint'],
          localSearch: item['localSearch'],
          isModal: item['isModal'] ?? false,
        );
      default:
        return emptyWidget;
    }
  }
}
