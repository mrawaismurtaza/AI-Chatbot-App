import 'package:chatbot/features/blocs/profile/profile_event.dart';
import 'package:chatbot/features/blocs/profile/profile_state.dart';
import 'package:chatbot/features/data/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await profileRepository.getProfile(event.userId);
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError('Failed to load profile'));
      }
    });

    on<UpdateProfile>((event, emit) async {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) {
          emit(ProfileError('User not authenticated'));
          return;
        }

        await profileRepository.updateProfile(userId, event.data);
        final updatedUser = await profileRepository.getProfile(userId);
        emit(ProfileLoaded(updatedUser));
      } catch (e) {
        emit(ProfileError('Failed to update profile'));
      }
    });

    on<UpdateProfilePicture>((event, emit) async {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) {
          emit(ProfileError('User not authenticated'));
          return;
        }

        final updatedUser = await profileRepository.updateProfilePicture(
          userId,
          event.image,
        );
        emit(ProfileLoaded(updatedUser));
      } catch (e) {
        emit(ProfileError('Failed to update profile picture: $e'));
      }
    });
  }
}
