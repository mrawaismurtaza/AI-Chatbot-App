import 'dart:io';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;
  LoadProfile(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
  UpdateProfile(this.data);
}

class UpdateProfilePicture extends ProfileEvent {
  final File image;
  UpdateProfilePicture(this.image);
}