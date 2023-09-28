import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/urls.dart';

final baseUrlProvider = Provider.autoDispose<String>((ref) {
  return Urls.baseUrl;
});
