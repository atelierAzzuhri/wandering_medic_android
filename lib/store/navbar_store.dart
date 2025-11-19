import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavbarIndexNotifier extends StateNotifier<int> {
  NavbarIndexNotifier() : super(0);

  void setIndex(int index) => state = index;
}

final navbarIndexProvider =
StateNotifierProvider<NavbarIndexNotifier, int>(
        (ref) => NavbarIndexNotifier());