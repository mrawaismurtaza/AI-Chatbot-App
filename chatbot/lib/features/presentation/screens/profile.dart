import 'package:chatbot/features/blocs/profile/profile_bloc.dart';
import 'package:chatbot/features/blocs/profile/profile_event.dart';
import 'package:chatbot/features/blocs/profile/profile_state.dart';
import 'package:chatbot/features/presentation/widgets/custom_button.dart';
import 'package:chatbot/features/presentation/widgets/image_picker.dart';
import 'package:chatbot/features/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(LoadProfile(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          final user = state.userData;
          final rawName = user['name'];
          final name =
              (rawName == null || rawName.toString().trim().isEmpty)
                  ? "Unnamed"
                  : rawName.toString();
          final profilePic = user['profile_pic'] ?? '';

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: Height * 0.1,
              horizontal: Width * 0.2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileImagePicker(profilePic: profilePic),
                const SizedBox(height: 16),
                Container(
                  width: Width * 0.6,
                  padding: EdgeInsets.symmetric(
                    vertical: Height * 0.02,
                    horizontal: Width * 0.02,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(name, style: theme.textTheme.bodyLarge),
                ),
                Container(
                  width: Width * 0.6,
                  padding: EdgeInsets.symmetric(
                    vertical: Height * 0.02,
                    horizontal: Width * 0.02,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(
                    "Privacy Policy >",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                Container(
                  width: Width * 0.6,
                  padding: EdgeInsets.symmetric(
                    vertical: Height * 0.02,
                    horizontal: Width * 0.02,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text("Others >", style: theme.textTheme.bodyLarge),
                ),
                CustomButton(
                  text: "Edit Profile",
                  onPressed: () {
                    _showEditingProfileDialog(context, name, theme);
                  },
                ),
                CustomButton(
                  text: "Log Out",
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    context.go(
                      '/login',
                    ); 
                  },
                ),
              ],
            ),
          );
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink(); // fallback for ProfileInitial
      },
    );
  }
}

void _showEditingProfileDialog(
  BuildContext context,
  String name,
  ThemeData theme,
) {
  final nameController = TextEditingController(text: name);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Profile"),
        content: CustomTextField(
          controller: nameController,
          hintText: "Enter new name",
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: theme.textTheme.bodyMedium),
              ),
              ElevatedButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    context.read<ProfileBloc>().add(
                      UpdateProfile({'name': newName}),
                    );
                    Fluttertoast.showToast(msg: 'Profile updated!');
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Save", style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ],
      );
    },
  );
}
