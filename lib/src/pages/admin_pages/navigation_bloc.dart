import 'dart:async';

class NavigationDrawerBloc {
  final StreamController navigationController = StreamController.broadcast();
  NavigationProvider navigationProvider = new NavigationProvider();

  Stream get getNavigation => navigationController.stream;

  void updateNavigation(String navigation) {
    navigationProvider.updateNavigation = navigation;
    navigationController.sink.add(navigationProvider.currentNavigation);
  }

  void dispose() {
    navigationController.close();
  }
}

final NavigationDrawerBloc bloc = NavigationDrawerBloc();

class NavigationProvider {
  String currentNavigation = "Clientes";

  String get updateNavigation => currentNavigation;

  set updateNavigation(String navigation) {
    currentNavigation = navigation;
  }
}
