import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_form/custom_date_form_field.dart';
import 'package:flutter_utils/widget/custom_form/custom_form_controller.dart';
import 'package:flutter_utils/widget/custom_form/custom_form_field_type.dart';
import 'package:flutter_utils/widget/custom_form/custom_form_widget.dart';
import 'package:flutter_utils/widget/custom_form/custom_select_form_field.dart';
import 'package:flutter_utils/widget/custom_form/custom_text_form_field.dart';
import 'package:flutter_utils/widget/custom_form/multi_select/multi_select_item.dart';
import 'package:flutter_utils/widget/custom_form/sf_date_picker_panel.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// jacokwu
/// 8/20/21 9:59 AM

class LogisticsQueryPage extends StatefulWidget {
  const LogisticsQueryPage({Key? key}) : super(key: key);

  @override
  _LogisticsQueryPageState createState() => _LogisticsQueryPageState();
}

class _LogisticsQueryPageState extends State<LogisticsQueryPage> {
  late Map<String, dynamic> _model;

  late CustomFormController _customFormController;

  @override
  void initState() {
    super.initState();
    _model = {};
    _customFormController = CustomFormController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '物流查询'),
        showDefaultBack: true,
      ),
      body: Container(
        child: Column(
          children: [
            CustomFormWidget(
              controller: _customFormController,
              formField: [
                {
                  'type': CustomFormFieldType.text,
                  'id': 'logisticNo',
                  'label': '单号',
                  'required': true,
                }
              ],
              model: _model,
              backgroundColor: Colors.white,
            ),
            TextButton(
                onPressed: () {
                  print(_model);
                  print(_customFormController.canSubmit!());
                },
                child: Text('查询')),
          ],
        ),
      ),
    );
  }
}
