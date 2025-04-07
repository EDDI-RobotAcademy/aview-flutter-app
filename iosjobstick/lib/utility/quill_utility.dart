import 'package:flutter_quill/quill_delta.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';


class QuillUtility {
  static String convertDeltaToHtml(Delta delta) {
    final converter = QuillDeltaToHtmlConverter(
      delta.toJson(),  // JSON 변환 후 사용›
      ConverterOptions(),
    );

    return converter.convert();
  }
}