import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var inAsync = false.obs;
  increment() => count++;
  change() => inAsync.value = !inAsync.value;
}

class BoolCubit extends Cubit<bool> {
  BoolCubit() : super(false);

  void change() => emit(!state);
}

abstract class MyState {}

class StartState extends MyState {}

class LoadState extends MyState {}

class EndState extends MyState {}

class AsyncCubit extends Cubit<MyState> {
  AsyncCubit() : super(StartState());

  Future<void> load() async {
    emit(LoadState());
    await Future.delayed(
      Duration(seconds: 2),
    );
    emit(EndState());
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myBloc = context.watch<AsyncCubit>();
    return ModalProgressHUD(
      inAsyncCall: myBloc.state is LoadState ? true : false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${myBloc.state}'),
              SimpleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AsyncCubit, MyState>(
      builder: (context, state) {
        return ElevatedButton(
          child: Text('call'),
          onPressed: () => context.read<AsyncCubit>().load(),
        );
      },
      listener: (context, state) {
        state is EndState
            ? Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => SecondPage(),
                ),
              )
            : null;
      },
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('second page'),
      ),
    );
  }
}
