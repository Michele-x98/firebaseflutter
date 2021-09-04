import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var inAsync = false.obs;
  increment() => count++;
  change() => inAsync.value = !inAsync.value;
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
    Get.to(SecondPage());
    emit(EndState());
  }
}

class HomeStream extends StatefulWidget {
  HomeStream({Key? key}) : super(key: key);

  @override
  _HomeStreamState createState() => _HomeStreamState();
}

class _HomeStreamState extends State<HomeStream> {
  final Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('/shopInfo').snapshots();

  String isShopOpen = '';
  String value = '';

  @override
  void initState() {
    collectionStream.listen((event) {
      print('somethings append');
      Map<String, dynamic> data =
          event.docs.first.data() as Map<String, dynamic>;
      value = data['isShopOpen'].toString();
      setState(() {});
    });
    super.initState();
  }

  changeDate() {
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection('shopInfo')
        .doc('sF3VJyfbTY8nWUBXWt14');
    collectionReference
        .update({'isShopOpen': isShopOpen == 'true' ? false : true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: changeDate,
                child: Text(isShopOpen == 'true' ? 'Close' : 'Open')),
            Text(value),
            StreamBuilder<QuerySnapshot>(
              stream: collectionStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Builder(
                  builder: (context) {
                    Map<String, dynamic> data = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    isShopOpen = data['isShopOpen'].toString();
                    return Text(isShopOpen == '' ? 'waiting..' : isShopOpen);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    CollectionReference enojy =
        FirebaseFirestore.instance.collection('EnjoySalad');
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
              FutureBuilder(
                future: enojy.doc('chiusura_negozio').get(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    print(data.toString());
                    return Text("IsShopOpen: ${data['isShopOpen']}");
                  }
                  return Text('data');
                },
              ),
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
        //Do somethings that require context
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
