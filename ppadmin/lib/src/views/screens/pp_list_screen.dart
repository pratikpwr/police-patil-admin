import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    BlocProvider.of<UsersBloc>(context).add(GetPPUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(POLICE_PATIL_APP),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                BlocProvider.of<UsersBloc>(context).add(GetPPUsers());
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
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
            BlocProvider.of<UsersBloc>(context).add(GetPPUsers());
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
    final _villageController = TextEditingController();
    String? psId;

    return await showDialog(
        context: context,
        builder: (context) {
          BlocProvider.of<VillagePSListBloc>(context).add(GetVillagePSList());
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
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                        child: Text("पोलीस पाटील जोडा",
                            style: Styles.primaryTextStyle())),
                    spacer(),
                    buildTextField(_nameController, NAME),
                    spacer(),
                    buildTextField(_emailController, USER_ID),
                    spacer(),
                    buildTextField(_passwordController, PASSWORD),
                    spacer(),
                    buildTextField(_villageController, VILLAGE),
                    spacer(),
                    BlocBuilder<VillagePSListBloc, VillagePSListState>(
                      builder: (context, state) {
                        if (state is VillagePSListLoading) {
                          return const Loading();
                        }
                        if (state is VillagePSListSuccess) {
                          return villageSelectDropDown(
                              isPs: true,
                              list: getPSListInString(state.policeStations),
                              selValue: psId,
                              onChanged: (value) {
                                psId = getPsIDFromPSName(
                                    state.policeStations, value!);
                              });
                        }
                        if (state is VillagePSListFailed) {
                          return SomethingWentWrong();
                        } else {
                          return SomethingWentWrong();
                        }
                      },
                    ),
                    spacer(),
                    CustomButton(
                        text: REGISTER,
                        onTap: () {
                          BlocProvider.of<UsersBloc>(context).add(
                              AddPolicePatil(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  psId: psId!,
                                  village: _villageController.text,
                                  role: "pp"));
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
            DataColumn(
                label: Text("Edit", style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text(NAME, style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text(VILLAGE, style: Styles.tableTitleTextStyle())),
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
              DataCell(IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  editPP(
                          context: context,
                          id: user.id!,
                          name: user.name!,
                          village: user.village!)
                      .then((_) {
                    BlocProvider.of<UsersBloc>(context).add(GetPPUsers());
                  });
                },
              )),
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

  Future<void> editPP(
      {required BuildContext context,
      required int id,
      required String name,
      required String village}) async {
    final _nameController = TextEditingController(text: name);
    final _villageController = TextEditingController(text: village);
    final _passwordController = TextEditingController();

    return await showDialog(
        context: context,
        builder: (context) {
          BlocProvider.of<VillagePSListBloc>(context).add(GetVillagePSList());
          return Dialog(
            child: BlocListener<UsersBloc, UsersState>(
              listener: (context, state) {
                if (state is UsersDataSendError) {
                  showSnackBar(context, state.error);
                  Navigator.pop(context);
                }
                if (state is UserDataUpdated) {
                  showSnackBar(context, state.message);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                        child: Text("पोलीस पाटील अपडेट",
                            style: Styles.primaryTextStyle())),
                    spacer(),
                    buildTextField(_nameController, NAME),
                    spacer(),
                    buildTextField(_villageController, VILLAGE),
                    spacer(),
                    buildTextField(_passwordController, PASSWORD),
                    spacer(),
                    CustomButton(
                        text: REGISTER,
                        onTap: () {
                          BlocProvider.of<UsersBloc>(context).add(EditPPUser(
                            id: id,
                            village: _villageController.text,
                            name: _nameController.text,
                            password: _passwordController.text,
                          ));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}
