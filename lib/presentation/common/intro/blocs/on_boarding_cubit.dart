import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class OnBoardingState extends Equatable {
  final int currentPage;
  const OnBoardingState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(const OnBoardingState(0));

  void setPage(int index) => emit(OnBoardingState(index));
}
