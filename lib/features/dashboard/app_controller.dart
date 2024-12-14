import 'package:flutter_riverpod/flutter_riverpod.dart';
class AppController {
  final bool extended;
  final int index;
  final bool showFAB;

  // Constructor
  const AppController({
    required this.extended,
    required this.index,
    required this.showFAB,
  });
}
class AppNotifier extends StateNotifier<AppController> {
  AppNotifier(super.state);

  // You can add methods to update the state here
  void toggleExtended() {
    state = AppController(
      extended: !state.extended,
      index: state.index,
      showFAB: state.showFAB,
    );
  }

  void setIndex(int newIndex) {
    state = AppController(
      extended: state.extended,
      index: newIndex,
      showFAB: state.showFAB,
    );
  }

  void toggleFAB() {
    state = AppController(
      extended: state.extended,
      index: state.index,
      showFAB: !state.showFAB,
    );
  }
}