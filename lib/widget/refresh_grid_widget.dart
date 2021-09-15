import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils/pages/error/no_data_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/24/21 5:03 PM

class RefreshGridWidget<T> extends StatefulWidget {
  final Future<List<T>> Function()? onRefresh;
  final Future<List<T>> Function()? onLoad;
  final EasyRefreshController? controller;
  final Widget Function(int index, T value) itemBuilder;
  final ScrollController? scrollController;
  final bool firstRefresh;
  final List<T>? dataSource;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;
  const RefreshGridWidget({
    Key? key,
    this.onRefresh,
    this.onLoad,
    this.controller,
    required this.itemBuilder,
    this.scrollController,
    this.firstRefresh = true,
    this.dataSource,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  }) : super(key: key);

  @override
  _RefreshGridWidgetState<T> createState() => _RefreshGridWidgetState<T>();
}

class _RefreshGridWidgetState<T> extends State<RefreshGridWidget<T>> {
  late List<T> dataSource;

  late EasyRefreshController controller;

  @override
  void initState() {
    super.initState();
    dataSource = widget.dataSource ?? [];
    controller = widget.controller ?? EasyRefreshController();
  }

  @override
  void didUpdateWidget(covariant RefreshGridWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataSource != null &&
        oldWidget.dataSource != null &&
        oldWidget.dataSource!.length != widget.dataSource!.length) {
      dataSource = widget.dataSource ?? [];
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: widget.firstRefresh,
      firstRefreshWidget: _buildFirstRefreshWidget(),
      controller: controller,
      scrollController: widget.scrollController,
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      emptyWidget: dataSource.length == 0 ? NoDataWidget() : null,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              widget.onRefresh!().then((value) {
                if (value.length == 0) {
                  if (controller.finishRefreshCallBack != null) controller.finishRefreshCallBack!(success: true);
                  return;
                }
                dataSource
                  ..clear()
                  ..addAll(value);
                if (controller.finishRefreshCallBack != null) controller..finishRefreshCallBack!(success: true);
                setState(() {});
              }).catchError((err) {
                // showToast('加载失败，请稍后重试');
                print(err);
                if (controller.finishRefreshCallBack != null) controller.finishRefreshCallBack!(success: false);
              });
            },
      onLoad: widget.onLoad == null
          ? null
          : () async {
              widget.onLoad!().then((value) {
                if (value.length > 0) {
                  dataSource.addAll(value);
                  if (controller.finishLoadCallBack != null)
                    controller.finishLoadCallBack!(success: true, noMore: false);
                } else {
                  if (controller.finishLoadCallBack != null)
                    controller.finishLoadCallBack!(success: true, noMore: true);
                  if (controller.resetLoadStateCallBack != null) controller.resetLoadStateCallBack!();
                }
                setState(() {});
              }).catchError((err) {
                // showToast('加载失败，请稍后重试');
                print(err);
                if (controller.finishLoadCallBack != null) controller.finishLoadCallBack!(success: false);
              });
            },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          childAspectRatio: widget.childAspectRatio,
          mainAxisExtent: widget.mainAxisExtent,
        ),
        itemBuilder: (_, index) => widget.itemBuilder(index, dataSource[index]),
        itemCount: dataSource.length,
        controller: widget.scrollController,
      ),
    );
  }

  Widget _buildFirstRefreshWidget() {
    return pageLoading(context);
  }
}
