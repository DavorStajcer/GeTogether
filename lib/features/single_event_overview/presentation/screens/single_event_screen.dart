import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/join_event_cubit/join_event_cubit.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/single_event_screen_cubit/single_event_screen_cubit.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/event_details.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/single_event_maps.dart';

class SingleEventScreen extends StatelessWidget {
  static const route = "/single_event_screen";
  const SingleEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 231, 246, 1),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SingleEventScreenCubit>(
            create: (context) => getIt<SingleEventScreenCubit>(),
          ),
          BlocProvider<JoinEventCubit>(
            create: (context) => getIt<JoinEventCubit>(),
          ),
        ],
        child: Builder(
          builder: (context) =>
              BlocBuilder<SingleEventScreenCubit, SingleEventScreenState>(
            builder: (context, state) {
              if (state is SingleEventScreenLoading) {
                BlocProvider.of<SingleEventScreenCubit>(context)
                    .checkIsAdminOfEventCurrentUser(event.adminId);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is SingleEventScreenFailure)
                return ServerErrorWidget(
                  state.message,
                  onReload: () {},
                );

              return Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: SingleEventMaps(event.location),
                  ),
                  Flexible(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: EventDetails(
                        event: event,
                        isCurrentUserEventAdmin:
                            (state as SingleEventScreenLoaded)
                                .isCurrentUserEventAdmin,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


/* 

 */