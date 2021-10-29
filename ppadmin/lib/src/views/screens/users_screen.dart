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
      appBar: AppBar(
          title: const Text("POLICE PATILS"), automaticallyImplyLeading: false),
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
                  child: UsersDetailsWidget(users: state.userResponse.data!),
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
                    buildTextField(_passwordController, PASSWORD),
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
  UsersDetailsWidget({Key? key, required this.users}) : super(key: key);
  final List<UserClass> users;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("ID", style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text(NAME, style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text("गाव", style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("Email", style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text(MOB_NO, style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text(GPS, style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("आदेश क्र.", style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("नेमणुकीची तारीख",
                    style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("नेमणुकीची मुदत",
                    style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("PSID", style: Styles.tableTitleTextStyle())),
          ],
          rows: List<DataRow>.generate(users.length, (index) {
            final user = users[index];
            return DataRow(cells: <DataCell>[
              customTextDataCell("${user.id ?? 0}"),
              customTextDataCell(user.name ?? "-"),
              customTextDataCell(user.village ?? "-"),
              customTextDataCell(user.email ?? "-"),
              user.photo != null
                  ? DataCell(ViewFileWidget(url: user.photo!))
                  : noDataInCell(),
              customTextDataCell("${user.mobile ?? 0}"),
              customTextDataCell(user.address ?? "-"),
              DataCell(ViewLocWidget(
                  id: "pp${user.id!}",
                  lat: user.latitude ?? 0.00,
                  long: user.longitude ?? 0.00)),
              customTextDataCell(user.orderNo ?? "-"),
              customTextDataCell(
                  user.joindate?.toIso8601String().substring(0, 10)),
              customTextDataCell(
                  user.enddate?.toIso8601String().substring(0, 10)),
              customTextDataCell("${user.psid ?? 0}"),
            ]);
          }),
        ),
      ),
    );
  }
}
