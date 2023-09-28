import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../../common/mixin/input_validation_mixin.dart';
import '../../../common/widgets/inputs/input_field.dart';
import '../../common/assets_constants.dart';
import '../../common/loader/custom_loader.dart';
import '../../common/styles/dimens.dart';
import '../../common/widgets/buttons/full_button.dart';
import '../../core/route/go_router_provider.dart';
import 'controller/login_controller.dart';
import 'controller/register_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with InputValidationMixin {
  //GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController nameController = TextEditingController();

  bool obscureText = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  bool hasCharacter = false;
  bool satisfiesLenght = false;
  bool hasNumber = false;
  checkPasswordStrength(String value) {
    if (hasCharacterRegEx.hasMatch(value)) {
      setState(() {
        hasCharacter = true;
      });
    }
    if (hasNumberRegEx.hasMatch(value)) {
      setState(() {
        hasNumber = true;
      });
    }
    if (value.length >= 8) {
      setState(() {
        satisfiesLenght = true;
      });
    }
    if (value.length < 8) {
      setState(() {
        satisfiesLenght = false;
      });
    }
    if (!hasNumberRegEx.hasMatch(value)) {
      setState(() {
        hasNumber = false;
      });
    }
    if (!hasCharacterRegEx.hasMatch(value)) {
      setState(() {
        hasCharacter = false;
      });
    }
  }

  Set<AccountType> selectedAccessories = <AccountType>{AccountType.individual};

  @override
  Widget build(BuildContext context) {
    final acceptTerms = ref.watch(accepTermsNotifier);
    final loading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: context.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Stack(
            children: [
              Form(
                key: ref.read(registerGlobalKey),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMedium * 1.2),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: kXXLarge,
                        ),
                        Center(
                          child: Image.asset(
                            AssetContants.appLogo,
                            height: kLeadingWidth * 1.4,
                            width: kLeadingWidth * 1.4,
                          ),
                        ),
                        const SizedBox(
                          height: kMedium,
                        ),
                        Text("Welcome to Substandard App",
                            style: context.titleLarge!
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(
                          height: kSmall,
                        ),
                        Text(
                          "Please Fill In the Form to proceed",
                          style: context.bodySmall,
                        ),

                        const SizedBox(
                          height: kXLMedium,
                        ),

                        InputField(
                          labelText: "Company Name",
                          controller: nameController,
                          hintText: 'Company Name ',
                          inputType: TextInputType.name,
                          validator: combine([
                            withMessage('company name is empty', isTextEmpty),
                          ]),
                        ),

                        const SizedBox(
                          height: kSmall,
                        ),
                        InputField(
                          labelText: "Email Address",
                          controller: emailController,
                          hintText: 'j@gmail.com',
                          inputType: TextInputType.emailAddress,
                          onChanged: (p0) {},
                          validator: combine([
                            withMessage('email is empty', isTextEmpty),
                            withMessage('email is invalid', isInvalidEmail),
                          ]),
                        ),

                        const SizedBox(
                          height: kSmall,
                        ),
                        InputField(
                          labelText: "Password",
                          controller: passwordController,
                          hintText: '***************',
                          obscureText: obscureText,
                          onChanged: (p0) {
                            checkPasswordStrength(
                                passwordController.text.trim());
                            ref
                                .read(registerControllerProvider.notifier)
                                .validateSave();
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          validator: combine([
                            withMessage('password is empty', isTextEmpty),
                            withMessage(
                                'password is invalid', isPasswordInvalid)
                          ]),
                        ),

                        // at least 8 character (a-z)
                        // at least 1 number (0-9)
                        passwordController.text.isEmpty
                            ? const SizedBox.shrink()
                            : PasswordStrength(context),
                        const SizedBox(
                          height: kSmall,
                        ),
                        InputField(
                          labelText: "Confirm Password",
                          controller: confirmPasswordController,
                          hintText: '***************',
                          obscureText: obscureText,
                          onChanged: (p0) {
                            ref
                                .read(registerControllerProvider.notifier)
                                .validateSave();
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          validator: combine([
                            withMessage('password is empty', isTextEmpty),
                            withMessage(
                                'password is invalid', isPasswordInvalid),
                            withMessage('Password did not match',
                                (confirmPassword) {
                              final password = passwordController.text;
                              if (confirmPassword != password) {
                                return ValidateFailResult.passwordNotMatch;
                              }
                              return null;
                            })
                          ]),
                        ),
                        const SizedBox(
                          height: kSmall,
                        ),
                        AcceptTerms(ref: ref, acceptTerms: acceptTerms),
                        const SizedBox(
                          height: kLarge,
                        ),
                        FullWidthButton(
                            buttonText: "Signup",
                            press: () async {
                              if (ref
                                  .read(registerControllerProvider.notifier)
                                  .validateSave()) {
                                if (acceptTerms) {
                                  ref
                                      .read(registerControllerProvider.notifier)
                                      .register(
                                          context: context,
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                } else {
                                  context.showSnackBar(
                                      "Accept terms and conditions to continue",
                                      color: context.errorColor);
                                }
                              } else {
                                context.showSnackBar(
                                    "Ensure all input fields are correct to continue",
                                    color: context.errorColor);
                              }
                            }),
                        const SizedBox(
                          height: kLarge,
                        ),

                        Center(
                          child: RichText(
                              text: TextSpan(
                                  text: "Have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                  children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.goNamed(AppRoute.login.name);
                                    },
                                ),
                              ])),
                        ),
                        const SizedBox(
                          height: kLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              loading ? const CustomLoader() : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Row PasswordStrength(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hasCharacter
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Icon(
                          hasCharacter ? Icons.check : Icons.cancel,
                          size: kMedium,
                          color: hasCharacter
                              ? context.primaryColor
                              : context.errorColor,
                        ),
                        const SizedBox(
                          width: kSmall,
                        ),
                        Text(
                          "at least 1 character (a-z)",
                          style: context.bodySmall!.copyWith(
                              color: hasCharacter
                                  ? context.primaryColor
                                  : context.errorColor),
                        ),
                      ],
                    ),
              hasNumber
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Icon(
                          hasNumber ? Icons.check : Icons.cancel,
                          size: kMedium,
                          color: hasNumber
                              ? context.primaryColor
                              : context.errorColor,
                        ),
                        const SizedBox(
                          width: kSmall,
                        ),
                        Text(
                          "at least 1 number (0-9)",
                          style: context.bodySmall!.copyWith(
                              color: hasNumber
                                  ? context.primaryColor
                                  : context.errorColor),
                        ),
                      ],
                    ),
              satisfiesLenght
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Icon(
                          satisfiesLenght ? Icons.check : Icons.cancel,
                          size: kMedium,
                          color: satisfiesLenght
                              ? context.primaryColor
                              : context.errorColor,
                        ),
                        const SizedBox(
                          width: kSmall,
                        ),
                        Text(
                          "satisfies length of 8",
                          style: context.bodySmall!.copyWith(
                              color: satisfiesLenght
                                  ? context.primaryColor
                                  : context.errorColor),
                        ),
                      ],
                    ),
            ],
          ),
        )
      ],
    );
  }
}

class Or extends StatelessWidget {
  const Or({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMedium),
          child: Text(
            "Or Continue with",
            style: context.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class AcceptTerms extends StatelessWidget {
  const AcceptTerms({
    super.key,
    required this.ref,
    required this.acceptTerms,
  });

  final WidgetRef ref;
  final bool acceptTerms;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(accepTermsNotifier.notifier).state = !acceptTerms;
          },
          child: Text(
            "Agree with the Terms & Conditions",
            style: context.bodyExtraSmall,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            return Checkbox(
                value: acceptTerms,
                onChanged: (value) {
                  ref.read(accepTermsNotifier.notifier).state = !acceptTerms;
                });
          },
        )
      ],
    );
  }
}

enum AccountType { individual, business }
