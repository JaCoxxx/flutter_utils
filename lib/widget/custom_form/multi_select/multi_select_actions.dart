import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'multi_select_item.dart';

/// jacokwu
/// 8/23/21 1:53 PM

class MultiSelectActions {
  List<String> onItemCheckedChange(
      List<String> selectedValues, String itemValue, bool checked) {
    if (checked) {
      selectedValues.add(itemValue);
    } else {
      selectedValues.remove(itemValue);
    }
    return selectedValues;
  }

  List<String> onItemSingleCheckedChange(
      List<String> selectedValues, String itemValue) {
    if (!selectedValues.contains(itemValue)) {
      selectedValues..clear()..add(itemValue);
    }
    return selectedValues;
  }

  /// Pops the dialog from the navigation stack and returns the initially selected values.
  void onCancelTap(BuildContext ctx, List<String> initiallySelectedValues) {
    Get.back(result: initiallySelectedValues);
  }

  /// Pops the dialog from the navigation stack and returns the selected values.
  /// Calls the onConfirm function if one was provided.
  void onConfirmTap(
      BuildContext ctx, List<String> selectedValues, Function(List<String>)? onConfirm) {
    Get.back(result: selectedValues);
    if (onConfirm != null) {
      onConfirm(selectedValues);
    }
  }

  /// Accepts the search query, and the original list of items.
  /// If the search query is valid, return a filtered list, otherwise return the original list.
  List<MultiSelectItem> updateSearchQuery(
      String? val, List<MultiSelectItem> allItems) {
    print(val);
    print(val!.toLowerCase());
    print(val != null && val.trim().isNotEmpty);
    if (val != null && val.trim().isNotEmpty) {
      List<MultiSelectItem> filteredItems = [];
      for (var item in allItems) {
        if (item.label.toLowerCase().contains(val.toLowerCase())) {
          filteredItems.add(item);
        }
      }
      return filteredItems;
    } else {
      return allItems;
    }
  }

  /// Toggles the search field.
  bool onSearchTap(bool showSearch) {
    return !showSearch;
  }
}
