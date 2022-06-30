import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/make_event/presentation/util/order_modifier.dart';

part 'event_card_order_state.dart';

class EventCardOrderCubit extends Cubit<EventCardOrderState> {
  final OrderModifier orderModifier;
  EventCardOrderCubit(this.orderModifier) : super(EventCardOrderInitial());

  void putToTop(EventType eventType) {
    final newOrder = orderModifier.moveToTop(state.eventTypeOrder, eventType);
    emit(EventCardOrderCustom(newOrder));
  }
}
