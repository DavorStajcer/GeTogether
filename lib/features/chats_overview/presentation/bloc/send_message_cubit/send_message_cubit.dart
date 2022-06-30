import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/send_message.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final SendMessage sendMessage;
  SendMessageCubit(this.sendMessage) : super(SendMessageNormal());

  void sendNewMessage(SendMessagePrameters sendMessagePrameters) async {
    if (state is SendMessageFailure) emit(SendMessageNormal());
    final response = await sendMessage(sendMessagePrameters);
    response.fold(
        (failure) => emit(
              SendMessageFailure(failure.message),
            ),
        (success) => null);
  }
}
