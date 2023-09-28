// ignore_for_file: avoid_single_cascade_in_expression_statements, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:substandard_products/common/extension/device_size.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';
import 'package:substandard_products/core/route/go_router_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;

import '../../backup_list_screen.dart';
import '../../common/helpers/helper.dart';
import '../../common/loader/custom_loader.dart';
import '../../common/styles/dimens.dart';
import '../../common/urls.dart';
import '../../common/widgets/buttons/full_button.dart';
import '../../models/file.dart';
import '../auth/controller/login_controller.dart';
import '../controller/files_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _decryptionKeyController =
      TextEditingController();
  bool _isGranted = true;
  String _filePath = '';

  String _backupFolderPath = '';
  String _encryptionKey = '';
  @override
  void initState() {
    requestStoragePermission();
    _createExternalVisibleDir();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(fileControllerProvider.notifier).files(context: context);
    });
    super.initState();
  }

  void _generateKey() {
    final key = enc.Key.fromSecureRandom(32);
    setState(() {
      _encryptionKey = key.base64;
    });
    print(_encryptionKey);
  }

  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        _isGranted = false;
      }
    }
  }

  ///I will use this insted to create a visible directory
  Future<String> _createExternalVisibleDir() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final backupDirectory = Directory('${directory!.path}/MyBackup');

    if (!await backupDirectory.exists()) {
      await backupDirectory.create();
    }
    setState(() {
      _backupFolderPath = backupDirectory.path;
    });

    return backupDirectory.path;
    // if (await Directory('/storage/emulated/0/MyBackup').exists()) {
    //   final externalDir = Directory('/storage/emulated/0/MyBackup');
    //   return externalDir.path;
    // } else {
    //   await Directory('/storage/emulated/0/MyBackup').create(recursive: true);
    //   final externalDir = Directory('/storage/emulated/0/MyBackup');
    //   setState(() {
    //     _backupFolderPath = externalDir.path;
    //   });
    //   return externalDir.path;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final fileState = ref.watch(fileControllerProvider);
    final uploadState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          context.pushNamed(AppRoute.addProduct.name);
        },
        label: Text("Upload Products"),
        icon: Icon(Icons.upload),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            fileState.files.isEmpty
                ? const Center(child: Text("No Products Available"))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kMedium),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref
                            .read(fileControllerProvider.notifier)
                            .files(context: context);
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: kMedium),
                          itemCount: fileState.files.length,
                          itemBuilder: (context, index) {
                            final file = fileState.files[index];
                            return InkWell(
                              onTap: () {
                                showBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(kSmall)),
                                    context: context,
                                    builder: (BuildContext snackContext) {
                                      return MyBottomSheet(file: file);
                                    });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                .secondaryHeaderColor),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            file.name != null
                                                ? "${Urls.baseUrl}${file.name!}"
                                                : Helpers.randomPictureUrl(),
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              file.users![0].user!.name!,
                                              style: context.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                            Text(
                                              file.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '£ ${file.price}',
                                                  style: context.bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ],
                              ),
                            );
                            // Card(
                            //     child: ListTile(
                            //   onTap: () {
                            //     showBottomSheet(
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(kSmall)),
                            //         context: context,
                            //         builder: (BuildContext snackContext) {
                            //           return MyBottomSheet(file: file);
                            //         });
                            //   },
                            //   title: Text(Urls.baseUrl + file.name!),
                            //   subtitle: Text(file.description!),
                            // ));
                          }),
                    ),
                  ),
            fileState.isLoading || uploadState
                ? const CustomLoader()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _downloadAndCreate(String url, String d, fileName) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      context.showSnackBar("File is Downloading");
      try {
        var resp = await http.get(Uri.parse(url));

        var encResult = _encryptData(resp.bodyBytes);
        print(d);
        String p = await _writeData(encResult, d + '/$fileName.aes');
        context.showSnackBar("File encrypted successfully: $p");
      } catch (e) {
        context.showSnackBar("Error: $e");
      }
    } else {
      context.showSnackBar("Cant launch URL", color: context.errorColor);
    }
  }

  _getNormalFile(String d, filename) async {
    Uint8List encData = await _readData(d + '/$filename.aes');
    var plainData = await _decryptData(encData);
    String p = await _writeData(plainData, d + '/$filename');
    context.showSnackBar("File decrypted successfully: $p");
  }

  _encryptData(plainString) {
    print("Encrypting File");

    final encrypted =
        MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
    return encrypted.bytes;
  }

  _decryptData(encData) {
    print("File Decrypting in progress...");
    enc.Encrypted en = enc.Encrypted(encData);
    return MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
  }

  Future<Uint8List> _readData(fileNameWithPath) async {
    print("Reading data...");
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

  Future<String> _writeData(dataToWrite, fileNameWithPath) async {
    try {
      print("Writing data...");
      File f = File(fileNameWithPath);
      await f.writeAsBytes(dataToWrite);
      print("Writing Complete...");
      return f.absolute.toString();
    } catch (e) {
      context.showSnackBar(e.toString());
      rethrow;
    }
  }
}

class MyEncrypt {
  //Special
  static final myKey = enc.Key.fromSecureRandom(32);
  static final myIv = enc.IV.fromSecureRandom(16);
  static final myEncrypter = enc.Encrypter(
      enc.AES(enc.Key.fromBase64(globalKey), mode: enc.AESMode.cbc));
}

class MyBottomSheet extends ConsumerStatefulWidget {
  const MyBottomSheet({
    super.key,
    required this.file,
  });
  final MyFile file;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends ConsumerState<MyBottomSheet> {
  final TextEditingController _decryptionKeyController =
      TextEditingController();

  RegExp regex = RegExp(r'[^/]*$');
  @override
  Widget build(BuildContext context) {
    print(globalKey);
    return Container(
      width: context.width,
      decoration: BoxDecoration(
          color: context.primaryColorLight,
          borderRadius: BorderRadius.circular(kSmall)),
      height: context.height * 0.6,
      padding: EdgeInsets.symmetric(horizontal: kMedium),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "${Urls.baseUrl}/uploads/files/${widget.file.sId}.png",
              height: 400,
              width: 400,
            )
          ],
        ),
      ),
    );
  }
}

var globalKey = '';
