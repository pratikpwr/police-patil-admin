import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:ppadmin/src/views/widgets/refresh_button.dart';
import 'package:shared/shared.dart';

class PoliceStationScreen extends StatefulWidget {
  const PoliceStationScreen({Key? key}) : super(key: key);

  @override
  State<PoliceStationScreen> createState() => _PoliceStationScreenState();
}

class _PoliceStationScreenState extends State<PoliceStationScreen> {
  @override
  void initState() {
    BlocProvider.of<UsersBloc>(context).add(GetPSUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(POLICE_STATION),
        automaticallyImplyLeading: false,
        actions: [
          RefreshButton(onTap: () async {
            BlocProvider.of<UsersBloc>(context).add(GetPSUsers());
          })
        ],
      ),
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersDataSendError) {
            showSnackBar(context, state.error);
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
                  child:
                      PoliceStationDetailsWidget(ps: state.userResponse.data!),
                ));
              }
            } else if (state is PoliceStationLoadError) {
              return SomethingWentWrong();
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewPoliceStation().then((_) {
            BlocProvider.of<UsersBloc>(context).add(GetPSUsers());
          });
        },
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Future<void> _addNewPoliceStation() async {
    final _nameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _emailController = TextEditingController();
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
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                        child: Text("पोलीस ठाणे जोडा",
                            style: Styles.primaryTextStyle())),
                    spacer(),
                    spacer(),
                    buildTextField(_nameController, NAME),
                    spacer(),
                    buildTextField(_emailController, USER_ID),
                    spacer(),
                    buildTextField(_passwordController, PASSWORD),
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
                          BlocProvider.of<UsersBloc>(context).add(AddPSUser(
                              role: "ps",
                              psId: psId!,
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

class PoliceStationDetailsWidget extends StatelessWidget {
  PoliceStationDetailsWidget({Key? key, required this.ps}) : super(key: key);
  final List<UserClass> ps;
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
            DataColumn(
                label: Text("Email", style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("PSID", style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("Role", style: Styles.tableTitleTextStyle())),
          ],
          rows: List<DataRow>.generate(ps.length, (index) {
            final user = ps[index];
            return DataRow(cells: <DataCell>[
              customTextDataCell("${user.id ?? 0}"),
              customTextDataCell(user.name ?? "-"),
              customTextDataCell(user.email ?? "-"),
              customTextDataCell(user.psid ?? "-"),
              customTextDataCell(user.role ?? "-"),
            ]);
          }),
        ),
      ),
    );
  }
}
