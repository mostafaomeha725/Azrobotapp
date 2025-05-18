part of 'getallspecialties_cubit.dart';

abstract class SpecialtiesState extends Equatable {
  const SpecialtiesState();

  @override
  List<Object> get props => [];
}

class SpecialtiesInitial extends SpecialtiesState {}

class SpecialtiesLoading extends SpecialtiesState {}

class SpecialtiesSuccess extends SpecialtiesState {
  final List<dynamic> specialties;

  const SpecialtiesSuccess({required this.specialties});

  @override
  List<Object> get props => [specialties];
}

class SpecialtiesFailure extends SpecialtiesState {
  final String errMessage;

  const SpecialtiesFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
