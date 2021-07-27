import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class Request {
  static final Request _instance = Request._internal();

  CancelToken _cancelToken = CancelToken();
  Dio _dio = Dio();

  String accessToken = '';
  String baseUrl = '';
  bool enableDebugPrint = true;

  final requestConfig = {
    'receiveTimeout': 20000,
    'sendTimeout': 20000,
  };

  factory Request() {
    return _instance;
  }

  Future init(String? baseUrl, String? accessToken) async {
    this.baseUrl = baseUrl!;
    this.accessToken = accessToken!;
    _dio.options.baseUrl = this.baseUrl;
    _dio.options.headers['Authorization'] = '$accessToken';
  }

  // 私有构造
  Request._internal() {
    BaseOptions _baseOptions = BaseOptions(
      sendTimeout: requestConfig['sendTimeout'],
      receiveTimeout: requestConfig['sendTimeout'],
    );

    /// 忽略ssl证书
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      ///忽略证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    _dio.options = _baseOptions;
    //  拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _print(response.requestOptions, response, null);
        handler.next(response);
      },
      onError: (DioError dioError, ErrorInterceptorHandler handler) {
        _print(dioError.requestOptions, dioError.response!, dioError);
        _checkToken(dioError.response!.statusCode);
        handler.next(dioError);
      },
    ));
  }

  // 错误处理
  dynamic _processError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
      return _getErrorResponse("连接超时", e.type.toString(), -1);
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
      return _getErrorResponse("请求超时", e.type.toString(), -1);
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
      return _getErrorResponse("响应超时", e.type.toString(), -1);
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("服务器响应异常");
      return _getErrorResponse("服务器响应异常", e.type.toString(), -1);
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("用户取消");
      return _getErrorResponse("用户取消", e.type.toString(), -1);
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误${e.error?.toString()}");
      return _getErrorResponse("Error: ${e.error}", e.type.toString(), -1);
    }
  }

  dynamic _getErrorResponse([message, errorType, code]) {
    Map error = Map();
    error['statusCode'] = code;
    if (message != null) {
      error['msg'] = message;
    }
    error['errorType'] = errorType;
    return error;
  }

  // 设置是否打印日志
  setEnableDebugPrint(bool enable) {
    this.enableDebugPrint = enable;
  }

  // 打印错误日志
  _print(RequestOptions request, Response response, DioError? error) async {
    if (enableDebugPrint) {
      int maxLineCount = 500;
      String errorStr = error != null
          ? '''
│[Error]
│${error.type}
│${error.message}
│${error.error.toString()}'''
          : '';

      String requestStr = '''
│[Request] ${request.method}
│url: ${request.baseUrl}${request.path}
│header: ${request.headers}${request.data != null ? "\n│body: " + (request.data is FormData ? request.data.fields.map((k) => "${k.key}:${k.value}").toList().toString() + request.data.files.map((k) => "(filename:${k.value.filename},length:${k.value.length})").toList().toString() : request.data.toString()) : ''}''';
      print("┌────────────────────────────────────────────────────────");
      print(requestStr);
      if (response != null) {
        String responseData = (response.data is Map || response.data is List)
            ? jsonEncode(
            response.data ?? (response.data is Map ? Map() : List.empty()))
            : "${response.data}";
        String responseStr = response != null
            ? "[Response] Code:${response.statusCode} Length:${responseData.length}\n│$responseData"
            : '';
        print("├────────────────────────────────────────────────────────");
        if (responseStr.length > maxLineCount) {
          for (int i = 0; i < responseStr.length; i += maxLineCount) {
            if (i + maxLineCount > responseStr.length) {
              print("│" + responseStr.substring(i, responseStr.length));
            } else {
              print("│" + responseStr.substring(i, i + maxLineCount));
            }
          }
        } else {
          print(responseStr);
        }
      }
      if (error != null) {
        print("├────────────────────────────────────────────────────────");
        print(errorStr);
      }
      print("└────────────────────────────────────────────────────────");
    }
  }

  // token校验
  void _checkToken(int? statusCode) {
    if (statusCode == 401) {
      _cancelToken.cancel();
    }
  }

// get请求
  Future get(String path,
      {token: true,
        ResponseType? responseType,
        String? contentType,
        int? sendTimeout,
        int? receiveTimeout,
        Map<String, dynamic>? headers,
        ProgressCallback? onReceiveProgress,
        cancelToken}) {
    return _get(
        path,
        token,
        responseType,
        contentType,
        sendTimeout,
        receiveTimeout,
        headers,
        onReceiveProgress,
        cancelToken ?? _cancelToken);
  }

  Future _get(
      String path,
      token,
      ResponseType? responseType,
      String? contentType,
      int? sendTimeout,
      int? receiveTimeout,
      Map<String, dynamic>? headers,
      ProgressCallback? onReceiveProgress,
      cancelToken) async {
    var response;
    try {
      response = await _dio.get(
        path,
        options: _getOptions(token, responseType!, contentType!,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioError catch (err) {
      return _processError(err);
    }
    return response.data;
  }

// post请求

  Future post(String path, dynamic data,
      {Options? options,
        token = true,
        ResponseType? responseType,
        String? contentType,
        int? sendTimeout,
        int? receiveTimeout,
        Map<String, dynamic>? headers,
        cancelToken,
        ProgressCallback? onReceiveProgress}) async {
    return _post(
        path,
        data,
        options!,
        token,
        responseType!,
        contentType!,
        sendTimeout != null ? sendTimeout : requestConfig['sendTimeout'],
        receiveTimeout != null ? receiveTimeout : requestConfig['receiveTimeout'],
        headers!,
        cancelToken ?? _cancelToken,
        onReceiveProgress!);
  }

  Future _post(
      String path,
      dynamic data,
      Options options,
      token,
      ResponseType responseType,
      String contentType,
      int? sendTimeout,
      int? receiveTimeout,
      Map<String, dynamic> headers,
      cancelToken,
      ProgressCallback onReceiveProgress) async {
    var response;
    try {
      response = await _dio.post(
        '$path',
        data: data,
        options: _getOptions(token, responseType, contentType,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioError catch (err) {
      return _processError(err);
    }
    return response.data;
  }

// put请求
  Future put(String path, dynamic data,
      {Options? options,
        token = true,
        ResponseType? responseType,
        String? contentType,
        int? sendTimeout,
        int? receiveTimeout,
        Map<String, dynamic>? headers,
        cancelToken,
        ProgressCallback? onReceiveProgress}) async {
    return _put(
        path,
        data,
        options!,
        token,
        responseType!,
        contentType!,
        sendTimeout ?? requestConfig['sendTimeout'],
        receiveTimeout ?? requestConfig['receiveTimeout'],
        headers!,
        cancelToken ?? _cancelToken,
        onReceiveProgress!);
  }

  Future _put(
      String path,
      dynamic data,
      Options options,
      token,
      ResponseType responseType,
      String contentType,
      int? sendTimeout,
      int? receiveTimeout,
      Map<String, dynamic> headers,
      cancelToken,
      ProgressCallback onReceiveProgress) async {
    var response;
    try {
      response = await _dio.put(
        path,
        data: data,
        options: _getOptions(token, responseType, contentType,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioError catch (err) {
      return _processError(err);
    }
    return response.data;
  }

// delete请求

  Future delete(
      String path,
      dynamic data, {
        Options? options,
        token = true,
        ResponseType? responseType,
        String? contentType,
        int? sendTimeout,
        int? receiveTimeout,
        Map<String, dynamic>? headers,
        cancelToken,
      }) async {
    return _delete(
        path,
        data,
        options!,
        token,
        responseType!,
        contentType!,
        sendTimeout ?? requestConfig['sendTimeout'],
        receiveTimeout ?? requestConfig['receiveTimeout'],
        headers!,
        cancelToken ?? _cancelToken);
  }

  Future _delete(
      String path,
      dynamic data,
      Options options,
      token,
      ResponseType responseType,
      String contentType,
      int? sendTimeout,
      int? receiveTimeout,
      Map<String, dynamic> headers,
      cancelToken) async {
    var response;
    try {
      response = await _dio.delete(
        path,
        data: data,
        options: _getOptions(token, responseType, contentType,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            headers: headers),
        cancelToken: cancelToken,
      );
    } on DioError catch (err) {
      return _processError(err);
    }
    return response.data;
  }

  // 设置请求参数
  Options _getOptions(
      token,
      ResponseType responseType,
      String contentType, {
        int? sendTimeout,
        int? receiveTimeout,
        Map<String, dynamic>? headers,
      }) {
    Options options = Options();
    if (responseType != null) options.responseType = responseType;
    if (contentType != null) options.contentType = contentType;
    if (headers != null)
      options.headers = headers;
    else
      options.headers = _dio.options.headers;
    if (token != null) {
      if (token is bool) {
        if (token)
          options.headers?['Authorization'] = "$accessToken";
        else
          options.headers?.remove('Authorization');
      } else {
        options.headers?['Authorization'] = "$token";
      }
    }
    options.sendTimeout = sendTimeout ?? requestConfig['sendTimeout'];
    options.receiveTimeout = receiveTimeout ?? requestConfig['receiveTimeout'];
    return options;
  }
}
