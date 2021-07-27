import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/widgets.dart';

import 'custom_divider.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap = 0,
    this.minVerticalPadding,
    // 24为icon默认大小
    this.minLeadingWidth = 24 + 10,
    this.needDefaultTrailing = false,
    this.divider,
    this.needDefaultDivider = false,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final MouseCursor? mouseCursor;
  final bool selected;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;

  /// 自定义参数

  /// 是否需要默认的 [trailing],权重高于 [trailing]
  final bool? needDefaultTrailing;

  /// 是否需要默认的下划线,权重高于 [divider]
  final bool? needDefaultDivider;

  /// 下划线
  final Widget? divider;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final ListTileTheme tileTheme = ListTileTheme.of(context);
    final TextDirection textDirection = Directionality.of(context);
    const EdgeInsets _defaultContentPadding = EdgeInsets.symmetric(horizontal: Dimens.pd16, vertical: Dimens.pd8);
    
    final MouseCursor resolvedMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled || (onTap == null && onLongPress == null))
          MaterialState.disabled,
        if (selected) MaterialState.selected,
      },
    );
    
    final EdgeInsets resolvedContentPadding = contentPadding?.resolve(textDirection)
        ?? tileTheme.contentPadding?.resolve(textDirection)
        ?? _defaultContentPadding;

    IconThemeData? iconThemeData;
    TextStyle? leadingAndTrailingTextStyle;
    if (leading != null || trailing != null) {
      iconThemeData = IconThemeData(color: _iconColor(theme, tileTheme));
      leadingAndTrailingTextStyle = _trailingAndLeadingTextStyle(theme, tileTheme);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: IconTheme.merge(
          data: iconThemeData!,
          child: leading!,
        ),
      );
    }

    final TextStyle titleStyle = _titleTextStyle(theme, tileTheme);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(theme, tileTheme);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null || needDefaultTrailing == true) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: IconTheme.merge(
          data: iconThemeData!,
          child: needDefaultTrailing == true ? _buildDefaultTrailing() : trailing!,
        ),
      );
    }

    return Column(
      children: [
        InkWell(
          customBorder: shape ?? ListTileTheme.of(context).shape,
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          mouseCursor: resolvedMouseCursor,
          canRequestFocus: enabled,
          focusNode: focusNode,
          focusColor: focusColor,
          hoverColor: hoverColor,
          autofocus: autofocus,
          enableFeedback: enableFeedback ??
              ListTileTheme.of(context).enableFeedback ??
              true,
          child: Semantics(
            selected: selected,
            enabled: enabled,
            child: Ink(
              decoration: ShapeDecoration(
                shape: shape ?? ListTileTheme.of(context).shape ?? const Border(),
                color: _tileBackgroundColor(ListTileTheme.of(context)),
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                minimum: resolvedContentPadding,
                child: Row(
                  children: [
                    if (leadingIcon != null)
                      Container(
                        alignment: Alignment.centerLeft,
                        width: minLeadingWidth,
                        child: leadingIcon,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            titleText,
                          if (subtitleText != null)
                            subtitleText,
                        ],
                      ),
                    ),
                    if (trailingIcon != null)
                      trailingIcon
                  ],
                ),
              ),
            ),
          ),
        ),
        needDefaultDivider == true
            ? _buildDefaultDivider()
            : divider ?? emptyWidget,
      ],
    );
  }

  Widget _buildDefaultTrailing() {
    return rightArrowIcon;
  }

  Widget _buildDefaultDivider() {
    return CustomDivider();
  }

  Color _tileBackgroundColor(ListTileTheme? tileTheme) {
    if (!selected) {
      if (tileColor != null)
        return tileColor!;
      if (tileTheme?.tileColor != null)
        return tileTheme!.tileColor!;
    }

    if (selected) {
      if (selectedTileColor != null)
        return selectedTileColor!;
      if (tileTheme?.selectedTileColor != null)
        return tileTheme!.selectedTileColor!;
    }

    return Colors.transparent;
  }

  Color? _iconColor(ThemeData theme, ListTileTheme? tileTheme) {
    if (!enabled)
      return theme.disabledColor;

    if (selected && tileTheme?.selectedColor != null)
      return tileTheme!.selectedColor;

    if (!selected && tileTheme?.iconColor != null)
      return tileTheme!.iconColor;

    switch (theme.brightness) {
      case Brightness.light:
      // For the sake of backwards compatibility, the default for unselected
      // tiles is Colors.black45 rather than colorScheme.onSurface.withAlpha(0x73).
        return selected ? theme.colorScheme.primary : Colors.black45;
      case Brightness.dark:
        return selected ? theme.colorScheme.primary : null; // null - use current icon theme color
    }
  }

  Color? _textColor(ThemeData theme, ListTileTheme? tileTheme, Color? defaultColor) {
    if (!enabled)
      return theme.disabledColor;

    if (selected && tileTheme?.selectedColor != null)
      return tileTheme!.selectedColor;

    if (!selected && tileTheme?.textColor != null)
      return tileTheme!.textColor;

    if (selected)
      return theme.colorScheme.primary;

    return defaultColor;
  }

  bool _isDenseLayout(ListTileTheme? tileTheme) {
    return dense ?? tileTheme?.dense ?? false;
  }

  TextStyle _titleTextStyle(ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style;
    if (tileTheme != null) {
      switch (tileTheme.style) {
        case ListTileStyle.drawer:
          style = theme.textTheme.bodyText1!;
          break;
        case ListTileStyle.list:
          style = theme.textTheme.subtitle1!;
          break;
      }
    } else {
      style = theme.textTheme.subtitle1!;
    }
    final Color? color = _textColor(theme, tileTheme, style.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(fontSize: 13.0, color: color)
        : style.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color? color = _textColor(theme, tileTheme, theme.textTheme.caption!.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(color: color, fontSize: 12.0)
        : style.copyWith(color: color);
  }

  TextStyle _trailingAndLeadingTextStyle(ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color? color = _textColor(theme, tileTheme, style.color);
    return style.copyWith(color: color);
  }
}
