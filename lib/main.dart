import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoreProvider(
        store: Store<AppState>(
          reducer,
          initialState: AppState.init(),
        ),
        child: const MyHomePage(),
      ),
    );
  }
}

class ViewModel {
  ViewModel({
    this.state,
    this.increment,
  });

  final AppState state;
  final VoidCallback increment;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewModel &&
          runtimeType == other.runtimeType &&
          state == other.state;

  @override
  int get hashCode => state.hashCode;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      converter: (store) {
        return ViewModel(
          state: store.state,
          increment: () {
            store.dispatch(UpdateCount(store.state.count + 1));
          },
        );
      },
      builder: (context, viewModel) {
        return MyHomePageContent(viewModel);
      },
    );
  }
}

class MyHomePageContent extends StatelessWidget {
  const MyHomePageContent(this.viewModel);

  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '${viewModel.state.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

@immutable
class AppState {
  AppState({
    @required this.count,
  });

  AppState.init()
      : this(
          count: 0,
        );

  final int count;

  AppState copyWith({
    int count,
  }) {
    return AppState(
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          count == other.count;

  @override
  int get hashCode => count.hashCode;
}

final Reducer<AppState> reducer = combineReducers<AppState>([
  TypedReducer(countReducer),
]);

AppState countReducer(AppState state, UpdateCount action) {
  return state.copyWith(count: action.count);
}

class UpdateCount {
  UpdateCount(this.count);
  final int count;
}
