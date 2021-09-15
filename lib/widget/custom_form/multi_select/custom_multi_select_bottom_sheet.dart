import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

import 'multi_select_actions.dart';
import 'multi_select_item.dart';

/// jacokwu
/// 8/23/21 1:18 PM

class MultiSelectBottomSheet extends StatefulWidget with MultiSelectActions {
  final List<MultiSelectItem> items;

  final List<String>? initialValue;

  final Widget? title;

  final void Function(List<String>)? onSelectionChanged;

  final void Function(List<String>)? onConfirm;

  final bool? searchable;

  final bool isSingle;

  final String confirmText;

  final String cancelText;

  final Color? selectedColor;

  final double? initialChildSize;

  final double? minChildSize;

  final double? maxChildSize;

  final String? searchHint;

  final Color? Function(String)? colorator;

  final Color? unselectedColor;

  final Icon? searchIcon;

  final Icon? closeSearchIcon;

  final TextStyle? itemsTextStyle;

  final TextStyle? selectedItemsTextStyle;

  final TextStyle? searchTextStyle;

  final TextStyle? searchHintStyle;

  final Color? checkColor;

  final Future<List<MultiSelectItem>> Function(String? keywords)? onRefresh;

  final Future<List<MultiSelectItem>> Function(String? keywords)? onLoad;

  final bool localSearch;

  const MultiSelectBottomSheet({
    Key? key,
    required this.items,
    required this.initialValue,
    this.title,
    this.onSelectionChanged,
    this.onConfirm,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.searchable,
    this.isSingle = false,
    this.selectedColor,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.colorator,
    this.unselectedColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchTextStyle,
    this.searchHint,
    this.searchHintStyle,
    this.selectedItemsTextStyle,
    this.checkColor,
    this.onRefresh,
    this.onLoad,
    this.localSearch = true,
  }) : super(key: key);

  @override
  _MultiSelectBottomSheetState createState() => _MultiSelectBottomSheetState();
}

class _MultiSelectBottomSheetState extends State<MultiSelectBottomSheet> {
  List<String> _selectedValues = [];
  bool _showSearch = false;
  late List<MultiSelectItem> _items;
  String? keywords;

  late EasyRefreshController _easyRefreshController;

  bool get isAll =>
      _selectedValues.length == _items.length &&
      _items.every((element) => _selectedValues.contains(element.value)) &&
      _selectedValues.length != 0;

  void initState() {
    super.initState();

    _easyRefreshController = EasyRefreshController();

    _items = widget.items;
    if (widget.initialValue != null && widget.initialValue!.length > 0) {
      _selectedValues.addAll(widget.initialValue!.map((e) => e));
    } else if (widget.isSingle) {
      _selectedValues.add('');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _items = [];
    keywords = null;
    _selectedValues = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(left: Dimens.pd12, right: Dimens.pd12, bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          _buildHeaderBox(),
          Expanded(
            child: RefreshListWidget<MultiSelectItem>(
                controller: _easyRefreshController,
                onRefresh: widget.onRefresh == null ? null : () => widget.onRefresh!(keywords),
                onLoad: widget.onLoad == null ? null : () => widget.onLoad!(keywords),
                dataSource: _items,
                firstRefresh: widget.onRefresh != null,
                itemBuilder: (index, value) => widget.isSingle ? _buildSingleListItem(value) : _buildListItem(value)),
          ),
          _buildFooterBox(),
        ],
      ),
    );
  }

  Widget _buildListItem(MultiSelectItem item) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
        accentColor: widget.selectedColor ?? Theme.of(context).primaryColor,
      ),
      child: CheckboxListTile(
        checkColor: widget.checkColor,
        value: _selectedValues.contains(item.value),
        activeColor:
            widget.colorator != null ? widget.colorator!(item.value) ?? widget.selectedColor : widget.selectedColor,
        title: Text(
          item.label,
          style: _selectedValues.contains(item.value) ? widget.selectedItemsTextStyle : widget.itemsTextStyle,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (checked) {
          setState(() {
            _selectedValues = widget.onItemCheckedChange(_selectedValues, item.value, checked!);
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(_selectedValues);
          }
        },
      ),
    );
  }

  Widget _buildSingleListItem(MultiSelectItem item) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
        accentColor: widget.selectedColor ?? Theme.of(context).primaryColor,
      ),
      child: RadioListTile(
        value: item.value,
        groupValue: _selectedValues[0],
        activeColor:
            widget.colorator != null ? widget.colorator!(item.value) ?? widget.selectedColor : widget.selectedColor,
        title: Text(
          item.label,
          style: _selectedValues.contains(item.value) ? widget.selectedItemsTextStyle : widget.itemsTextStyle,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (String? value) {
          setState(() {
            _selectedValues = widget.onItemSingleCheckedChange(_selectedValues, item.value);
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(_selectedValues);
          }
        },
      ),
    );
  }

  Widget _buildHeaderBox() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _showSearch
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      autofocus: true,
                      style: widget.searchTextStyle,
                      decoration: InputDecoration(
                        hintStyle: widget.searchHintStyle,
                        hintText: widget.searchHint ?? "搜索",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.selectedColor ?? Theme.of(context).primaryColor),
                        ),
                      ),
                      onSubmitted: (val) async {
                        keywords = val;
                        await Future.delayed(Duration(milliseconds: 300));
                        if (widget.localSearch) {
                          _items = widget.updateSearchQuery(val, widget.items);
                        } else {
                          _easyRefreshController.callRefresh();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                )
              : widget.title ??
                  Text(
                    "选择",
                    style: TextStyle(fontSize: 18),
                  ),
          widget.searchable != null && widget.searchable!
              ? IconButton(
                  icon: _showSearch
                      ? widget.closeSearchIcon ?? Icon(Icons.close)
                      : widget.searchIcon ?? Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        _items = widget.items;
                        keywords = null;
                        _easyRefreshController.callRefresh();
                      }
                    });
                  },
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                ),
        ],
      ),
    );
  }

  Widget _buildFooterBox() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0,
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        constraints: const BoxConstraints(minHeight: 52.0),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: <Widget>[
            if (!widget.isSingle)
              Expanded(
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
                    accentColor: widget.selectedColor ?? Theme.of(context).primaryColor,
                  ),
                  child: CheckboxListTile(
                    value: isAll,
                    checkColor: widget.checkColor,
                    activeColor: widget.selectedColor,
                    title: Text(
                      '全选',
                      style: isAll ? widget.selectedItemsTextStyle : widget.itemsTextStyle,
                    ),
                    onChanged: (value) {
                      print(isAll);
                      print(_selectedValues.length);
                      if (isAll) {
                        _selectedValues.clear();
                      } else {
                        _selectedValues
                          ..clear()
                          ..addAll(_items.map((e) => e.value));
                      }
                      setState(() {});
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ),
            if (widget.isSingle) Spacer(),
            TextButton(
              child: Text(
                widget.cancelText,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                widget.onCancelTap(context, widget.initialValue!);
              },
            ),
            TextButton(
              child: Text(
                widget.confirmText,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                widget.onConfirmTap(context, _selectedValues, widget.onConfirm);
              },
            ),
          ],
        ),
      ),
    );
  }
}
