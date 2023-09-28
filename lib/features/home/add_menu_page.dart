import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';
import 'package:substandard_products/core/route/go_router_provider.dart';

import '../../../../common/badge/no_internet_badge.dart';

import '../../../../common/mixin/input_validation_mixin.dart';
import '../../../../core/provider/connectivity_provider.dart';
import '../../common/loader/custom_loader.dart';
import '../../common/styles/dimens.dart';
import '../../common/widgets/buttons/full_button.dart';
import '../../common/widgets/inputs/input_field.dart';
import '../../core/services/contract_services.dart';
import '../auth/controller/login_controller.dart';
import '../auth/controller/register_controller.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider);
    final connectivity = ref.watch(connectivityProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Visibility(
            visible: !connectivity.isOnline,
            child: const NoInternetBanner(),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Add Product",
                        style: context.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const AddMenuFormSection()
                  ],
                ),
              ),
              loading ? const CustomLoader() : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

class AddMenuFormSection extends ConsumerStatefulWidget {
  const AddMenuFormSection({
    super.key,
  });

  @override
  ConsumerState<AddMenuFormSection> createState() => _AddMenuFormSectionState();
}

class _AddMenuFormSectionState extends ConsumerState<AddMenuFormSection>
    with InputValidationMixin {
  GlobalKey<FormState> addMenuKey = GlobalKey<FormState>();
  File? _image;
  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);
      setState(() {
        _image = imagePermanent;
      });
    } on PlatformException catch (e) {
      rootNavigator.currentContext!.showSnackBar(e.toString(),
          color: rootNavigator.currentContext!.errorColor);
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  bool obscureText = true;
  List<int> selectedFoodCategory = [];
  List<int> selectedFoodSubCategory = [];
  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acceptTerms = ref.watch(accepTermsNotifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: addMenuKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            InputField(
              labelText: "Title",
              controller: titleController,
              hintText: 'fugit',
              inputType: TextInputType.text,
              validator: combine([
                withMessage('Title is empty', isTextEmpty),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              labelText: "Price",
              controller: priceController,
              hintText: '50',
              suffixIcon: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text("£")),
              inputType: TextInputType.number,
              validator: combine([
                withMessage('Price is empty', isTextEmpty),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              maxlines: 5,
              labelText: "Description",
              controller: descriptionController,
              hintText: 'earum',
              inputType: TextInputType.text,
              validator: combine([
                withMessage('Description is empty', isTextEmpty),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Menu Image"),
            const SizedBox(
              height: kSmall,
            ),
            Container(
              decoration: BoxDecoration(
                  color: context.tertially,
                  borderRadius: BorderRadius.circular(kSmall)),
              child: DottedBorder(
                borderType: BorderType.RRect,
                padding: _image == null
                    ? const EdgeInsets.symmetric(vertical: kSmall)
                    : const EdgeInsets.all(0),
                radius: const Radius.circular(kSmall),
                dashPattern: const [10, 4],
                color: Colors.black54,
                strokeCap: StrokeCap.round,
                child: _image != null
                    ? Image.file(
                        _image!,
                        height: 150,
                        width: context.width,
                        fit: BoxFit.fill,
                      )
                    : Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: context.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(kSmall))),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          icon: Icon(
                            Icons.file_upload_outlined,
                            color: context.onPrimary,
                          ),
                          label: Text("Upload Image",
                              style: context.bodySmall!
                                  .copyWith(color: context.onPrimary)),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(accepTermsNotifier.notifier).state = !acceptTerms;
                  },
                  child: Text(
                    "Mark product as counterfeit",
                    style: context.bodySmall,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return Checkbox(
                        value: acceptTerms,
                        onChanged: (value) {
                          ref.read(accepTermsNotifier.notifier).state =
                              !acceptTerms;
                        });
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FullWidthButton(
                buttonText: 'Save',
                press: () {
                  if (validateSave()) {
                    final contractServices = ContractServices();
                    contractServices.addContract(
                      titleController.text,
                      descriptionController.text,
                    );
                    // if (_image == null) {
                    //   context.showSnackBar("Menu Image is required",
                    //       color: context.errorColor);
                    // } else {

                    ref.read(authControllerProvider.notifier).upload(
                        context: context,
                        price: priceController.text.trim(),
                        blocked: false,
                        description: descriptionController.text.trim(),
                        file: _image!);
                    // }
                  }
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  bool validateSave() {
    final form = addMenuKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
