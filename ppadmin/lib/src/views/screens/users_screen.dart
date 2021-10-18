import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:shared/shared.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UsersBloc>(context).add(GetUsers());
    return Scaffold(
      appBar: CustomAppBar(title: IMP_NEWS),
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersDataLoading) {
              return const Loading();
            } else if (state is UsersDataLoaded) {
              if (state.userResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.userResponse.data!.length,
                      itemBuilder: (context, index) {
                        return UsersDetailsWidget(
                            user: state.userResponse.data![index]);
                      }),
                ));
              }
            } else if (state is UsersLoadError) {
              return SomethingWentWrong();
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewUsers().then((_) {
            BlocProvider.of<UsersBloc>(context).add(GetUsers());
          });
        },
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Future<void> _addNewUsers() async {
    final _nameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _emailController = TextEditingController();

    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BlocListener<UsersBloc, UsersState>(
              listener: (context, state) {
                if (state is UsersDataSendError) {
                  showSnackBar(context, state.error);
                  Navigator.pop(context);
                }
                if (state is UsersDataSent) {
                  showSnackBar(context, state.message);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    spacer(),
                    buildTextField(_nameController, NAME),
                    spacer(),
                    buildTextField(_emailController, "Email"),
                    spacer(),
                    buildTextField(_passwordController, "Password"),
                    spacer(),
                    CustomButton(
                        text: REGISTER,
                        onTap: () {
                          BlocProvider.of<UsersBloc>(context).add(AddUser(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class UsersDetailsWidget extends StatelessWidget {
  const UsersDetailsWidget({Key? key, required this.user}) : super(key: key);
  final UserClass user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GREY_BACKGROUND_COLOR),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name!,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Divider(),
              Text(
                user.email!,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
