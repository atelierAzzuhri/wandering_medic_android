import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // number of stack trace lines
    errorMethodCount: 5, // stack trace lines for errors
    lineLength: 80, // wrap lines after this length
    colors: true, // color output
    printEmojis: true, // add emojis
  ),
);
