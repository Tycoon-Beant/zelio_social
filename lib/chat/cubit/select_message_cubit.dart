import 'package:flutter_bloc/flutter_bloc.dart';

class SelectMessageCubit extends Cubit<SelectMessageState> {
  SelectMessageCubit()
      : super(SelectMessageState(isEditing: false, selectedMessages: []));

  void selecteMessages(String messageId) {
    if (state.isEditing) return;
    emit(SelectMessageState(
      isEditing: true,
      selectedMessages: [messageId],
    ));
  }

  void deSelectMessages(String messageId) {
    if (state.isEditing) {
      final list = _toggledMessages(messageId);
      emit(state.copyWith(
        isEditing: list.isNotEmpty,
        selectedMessages: list,
      ));
    }
  }

  List<String> _toggledMessages(String messageId) {
    if (state.selectedMessages.contains(messageId)) {
      return state.selectedMessages.where((id) => id != messageId).toList();
    }
    return [...state.selectedMessages, messageId];
  }

  void clearMessageList() {
    emit(state.copyWith(isEditing: false, selectedMessages: []));
  }
}

class SelectMessageState {
  final bool isEditing;
  final List<String> selectedMessages;

  SelectMessageState({
    required this.isEditing,
    required this.selectedMessages,
  });

  bool isSelected(String messageId) {
    return selectedMessages.contains(messageId);
  }

  SelectMessageState copyWith({
    bool? isEditing,
    List<String>? selectedMessages,
  }) {
    return SelectMessageState(
      isEditing: isEditing ?? this.isEditing,
      selectedMessages: selectedMessages ?? this.selectedMessages,
    );
  }
}
