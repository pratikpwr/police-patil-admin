import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<WatchRegisterBloc>(context).add(GetWatchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WATCH_REGISTER),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const WatchFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<WatchRegisterBloc, WatchRegisterState>(
        listener: (context, state) {
          if (state is WatchLoadError) {
            showSnackBar(context, state.message.substring(0, 200));
          }
        },
        child: BlocBuilder<WatchRegisterBloc, WatchRegisterState>(
          builder: (context, state) {
            if (state is WatchDataLoading) {
              return const Loading();
            } else if (state is WatchDataLoaded) {
              return SafeArea(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spacer(),
                          WatchDataTableWidget(
                              watchList: state.watchResponse.data!),
                        ],
                      )),
                ),
              );
            } else if (state is WatchLoadError) {
              if (state.message == 'Record Empty') {
                return NoRecordFound();
              } else {
                return SomethingWentWrong();
              }
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 24),
        onPressed: () {
          _addWatchData().then((_) {
            BlocProvider.of<WatchRegisterBloc>(context).add(GetWatchData());
          });
        },
      ),
    );
  }

  Future<void> _addWatchData() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return const AddWatchDataWidget();
        });
  }
}

class AddWatchDataWidget extends StatefulWidget {
  const AddWatchDataWidget({Key? key}) : super(key: key);

  @override
  _AddWatchDataWidgetState createState() => _AddWatchDataWidgetState();
}

class _AddWatchDataWidgetState extends State<AddWatchDataWidget> {
  final _bloc = WatchRegisterBloc();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<VillagePSListBloc>(context).add(GetVillagePSList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        // height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.4,
        child: BlocListener<WatchRegisterBloc, WatchRegisterState>(
          listener: (context, state) {
            if (state is WatchDataSendError) {
              showSnackBar(context, state.error);
            }
            if (state is WatchDataSent) {
              Navigator.pop(context);
              showSnackBar(context, state.message);
            }
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              spacer(),
              buildDropButton(
                  value: _bloc.chosenValue,
                  items: _bloc.watchRegTypes,
                  hint: "निगराणी प्रकार निवडा",
                  onChanged: (String? value) {
                    setState(() {
                      _bloc.chosenValue = value;
                    });
                  }),
              spacer(),
              buildTextField(_nameController, NAME),
              spacer(),
              buildTextField(_phoneController, MOB_NO),
              spacer(),
              AttachButton(
                text: _bloc.photoName,
                onTap: () async {
                  getFileFromDevice(context).then((pickedFile) {
                    setState(() {
                      _bloc.photo = pickedFile;
                      _bloc.photoName = getFileName(pickedFile!.path);
                    });
                  });
                },
              ),
              spacer(),
              buildTextField(_addressController, ADDRESS),
              spacer(),
              BlocBuilder<VillagePSListBloc, VillagePSListState>(
                builder: (context, state) {
                  if (state is VillagePSListLoading) {
                    return const Loading();
                  }
                  if (state is VillagePSListSuccess) {
                    return Column(
                      children: [
                        villageSelectDropDown(
                            isPs: true,
                            list: getPSListInString(state.policeStations),
                            selValue: _bloc.psId,
                            onChanged: (value) {
                              _bloc.psId = getPsIDFromPSName(
                                  state.policeStations, value!);
                            }),
                        spacer(),
                        villageSelectDropDown(
                            list: getVillageListInString(state.villages),
                            selValue: _bloc.ppId,
                            onChanged: (value) {
                              _bloc.ppId =
                                  getPpIDFromVillage(state.villages, value!);
                            }),
                      ],
                    );
                  }
                  if (state is VillagePSListFailed) {
                    return SomethingWentWrong();
                  } else {
                    return SomethingWentWrong();
                  }
                },
              ),
              spacer(),
              TextField(
                controller: _otherController,
                style: Styles.inputFieldTextStyle(),
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: OTHER_INFO,
                    hintStyle: Styles.inputFieldTextStyle(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              spacer(),
              CustomButton(
                  text: DO_REGISTER,
                  onTap: () async {
                    WatchData _watchData = WatchData(
                        type: _bloc.chosenValue,
                        name: _nameController.text,
                        mobile: parseInt(_phoneController.text),
                        photo: _bloc.photo?.path != null
                            ? await MultipartFile.fromFile(_bloc.photo!.path)
                            : " ",
                        address: _addressController.text,
                        latitude: 0.00,
                        longitude: 0.00,
                        ppid: int.parse(_bloc.ppId!),
                        psid: int.parse(_bloc.psId!),
                        description: _otherController.text);

                    BlocProvider.of<WatchRegisterBloc>(context)
                        .add(AddWatchData(_watchData));
                  }),
              spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class WatchDataTableWidget extends StatelessWidget {
  WatchDataTableWidget({Key? key, required this.watchList}) : super(key: key);
  final List<WatchData> watchList;

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
                DataColumn(
                    label: Text(TYPE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(NAME, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(MOB_NO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label:
                        Text(AADHAR_CARD, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label:
                        Text(OTHER_INFO, style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(watchList.length, (index) {
                final watchData = watchList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    watchData.type!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    watchData.name ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${watchData.mobile ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  watchData.photo != null
                      ? DataCell(ViewFileWidget(url: watchData.photo!))
                      : noDataInCell(),
                  watchData.aadhar != null
                      ? DataCell(ViewFileWidget(url: watchData.aadhar!))
                      : noDataInCell(),
                  DataCell(Text(
                    watchData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "watch${watchData.id!}",
                      lat: watchData.latitude!,
                      long: watchData.longitude!)),
                  DataCell(Text(
                    "${watchData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${watchData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(watchData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(SizedBox(
                    width: 400,
                    child: Text(
                      watchData.description ?? "-",
                      maxLines: 3,
                      style: Styles.tableValuesTextStyle(),
                    ),
                  )),
                ]);
              }))),
    );
  }
}

class WatchFilterDataWidget extends StatefulWidget {
  const WatchFilterDataWidget({Key? key}) : super(key: key);

  @override
  _WatchFilterDataWidgetState createState() => _WatchFilterDataWidgetState();
}

class _WatchFilterDataWidgetState extends State<WatchFilterDataWidget> {
  final _bloc = WatchRegisterBloc();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<VillagePSListBloc>(context).add(GetVillagePSList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(32),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.4,
        child: BlocBuilder<VillagePSListBloc, VillagePSListState>(
          builder: (context, state) {
            if (state is VillagePSListLoading) {
              return const Loading();
            }
            if (state is VillagePSListSuccess) {
              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  spacer(),
                  buildDropButton(
                      value: _bloc.chosenType,
                      items: _bloc.types,
                      hint: CHOSE_TYPE,
                      onChanged: (String? value) {
                        setState(() {
                          _bloc.chosenType = value;
                        });
                      }),
                  spacer(),
                  villageSelectDropDown(
                      isPs: true,
                      list: getPSListInString(state.policeStations),
                      selValue: _bloc.psId,
                      onChanged: (value) {
                        _bloc.psId =
                            getPsIDFromPSName(state.policeStations, value!);
                      }),
                  spacer(),
                  villageSelectDropDown(
                      list: getVillageListInString(state.villages),
                      selValue: _bloc.ppId,
                      onChanged: (value) {
                        _bloc.ppId = getPpIDFromVillage(state.villages, value!);
                      }),
                  spacer(),
                  buildDateTextField(context, _fromController, DATE_FROM),
                  spacer(),
                  buildDateTextField(context, _toController, DATE_TO),
                  spacer(),
                  CustomButton(
                      text: APPLY_FILTER,
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<WatchRegisterBloc>(context).add(
                            GetWatchData(
                                type: _bloc.chosenType,
                                ppId: _bloc.ppId,
                                psId: _bloc.psId,
                                fromDate: _fromController.text,
                                toDate: _toController.text));
                      })
                ],
              );
            }
            if (state is VillagePSListFailed) {
              return SomethingWentWrong();
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
    );
  }
}
