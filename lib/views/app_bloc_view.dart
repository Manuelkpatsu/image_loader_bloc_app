import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_loader_bloc_app/bloc/app_bloc.dart';
import 'package:image_loader_bloc_app/bloc/app_state.dart';
import 'package:image_loader_bloc_app/bloc/bloc_events.dart';
import 'package:image_loader_bloc_app/bloc/extensions/stream/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            // we have an error
            return const Center(
              child: Text('An error occurred. Try again in a minute'),
            );
          } else if (appState.data != null) {
            // we have data
            return Image.memory(
              appState.data!,
              fit: BoxFit.fitHeight,
            );
          } else {
            // loading
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
