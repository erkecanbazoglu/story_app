import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/internet_cubit.dart';

class FirstPage extends StatefulWidget {
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   "1",
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetConnected &&
                    state.connectionType == ConnectionType.Wifi) {
                  return Text(
                    "Wifi",
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else if (state is InternetConnected &&
                    state.connectionType == ConnectionType.Mobile) {
                  return Text(
                    "Mobile",
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else if (state is InternetDisconnected) {
                  return Text(
                    "No Internet",
                    style: Theme.of(context).textTheme.headline4,
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
