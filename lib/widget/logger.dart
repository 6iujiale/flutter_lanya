// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:logger/logger.dart';

// ignore: camel_case_types
class logUtil {
  late var logger;

  logUtil() {
    logger = Logger(printer: PrefixPrinter(PrettyPrinter(colors: false)));
  }

  void debug(msg) {
    logger.d(msg);
  }
}
