part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic> profileData;

  ProfileSuccess({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class ProfileFailure extends ProfileState {
  final String errMessage;

  ProfileFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
