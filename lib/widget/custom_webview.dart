import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// jacokwu
/// 7/29/21 10:17 AM

class CustomWebView extends StatelessWidget {
  final void Function(WebViewController)? onWebViewCreated;
  final String? initialUrl;
  final JavascriptMode javascriptMode;
  final Set<JavascriptChannel>? javascriptChannels;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      navigationDelegate;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final void Function(String)? onPageStarted;
  final void Function(String)? onPageFinished;
  final void Function(int)? onProgress;
  final void Function(WebResourceError)? onWebResourceError;
  final bool debuggingEnabled;
  final bool gestureNavigationEnabled;
  final String? userAgent;
  final AutoMediaPlaybackPolicy initialMediaPlaybackPolicy;
  final bool allowsInlineMediaPlayback;

  const CustomWebView({
    Key? key,
    this.onWebViewCreated,
    this.initialUrl,
    this.javascriptChannels,
    this.navigationDelegate,
    this.gestureRecognizers,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.userAgent,
    this.javascriptMode = JavascriptMode.disabled,
    this.gestureNavigationEnabled = false,
    this.allowsInlineMediaPlayback = false,
    this.debuggingEnabled = false,
    this.initialMediaPlaybackPolicy =
        AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: onWebViewCreated,
      initialUrl: initialUrl,
      javascriptChannels: javascriptChannels,
      navigationDelegate: navigationDelegate,
      gestureRecognizers: gestureRecognizers,
      onPageStarted: onPageStarted ?? _defaultOnPageStarted,
      onPageFinished: onPageFinished ?? _defaultOnPageFinished,
      onProgress: onProgress ?? _defaultOnProgress,
      onWebResourceError: onWebResourceError ?? _defaultOnWebResourceError,
      userAgent: userAgent,
      javascriptMode: javascriptMode,
      gestureNavigationEnabled: gestureNavigationEnabled,
      allowsInlineMediaPlayback: allowsInlineMediaPlayback,
      debuggingEnabled: debuggingEnabled,
      initialMediaPlaybackPolicy: initialMediaPlaybackPolicy,
    );
  }

  void _defaultOnPageStarted(String url) {
    showLoading();
  }

  void _defaultOnPageFinished(String url) {
    dismissLoading();
  }

  void _defaultOnProgress(int current) {
    print(current);
  }

  void _defaultOnWebResourceError(WebResourceError error) {
    print(error.description);
    print(error.domain);
    print(error.errorCode);
    print(error.errorType);
    print(error.failingUrl);
  }
}
