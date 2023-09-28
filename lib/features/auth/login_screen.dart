import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../../common/loader/custom_loader.dart';
import '../../../common/mixin/input_validation_mixin.dart';
import '../../../common/widgets/inputs/input_field.dart';
import '../../common/assets_constants.dart';
import '../../common/styles/dimens.dart';
import '../../common/widgets/buttons/full_button.dart';
import '../../core/route/go_router_provider.dart';
import 'controller/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with InputValidationMixin {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscureText = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rememberMe = ref.watch(rememberMeNotifier);
    final loading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: loginKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kMedium * 1.2),
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
                        height: kLarge,
                      ),
                      Text("Welcome to Substandard App",
                          style: context.titleLarge!
                              .copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(
                        height: kSmall,
                      ),
                      Text(
                        "Stay signed in with your account to make work easier",
                        textAlign: TextAlign.center,
                        style: context.bodySmall,
                      ),
                      const SizedBox(
                        height: kLarge,
                      ),
                      InputField(
                        labelText: "Email Address",
                        controller: emailController,
                        hintText: 'j@gmail.com',
                        inputType: TextInputType.emailAddress,
                        validator: combine([
                          withMessage('email is empty', isTextEmpty),
                          withMessage('email is invalid', isInvalidEmail)
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
                          withMessage('password is invalid', isPasswordInvalid)
                        ]),
                      ),
                      const SizedBox(
                        height: kSmall,
                      ),
                      RememberMe(ref: ref, rememberMe: rememberMe),
                      const SizedBox(
                        height: kXLarge,
                      ),
                      FullWidthButton(
                          buttonText: "Sign In",
                          press: () {
                            if (validateSave()) {
                              ref.read(authControllerProvider.notifier).login(
                                  context: context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                            }
                          }),
                      const SizedBox(
                        height: kLarge,
                      ),
                      Center(
                        child: RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14),
                                children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.goNamed(AppRoute.register.name);
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
            loading ? CustomLoader() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  bool validateSave() {
    final form = loginKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

///The Or widget
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

///Remember me widget
class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
    required this.ref,
    required this.rememberMe,
  });

  final WidgetRef ref;
  final bool rememberMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(rememberMeNotifier.notifier).state = !rememberMe;
          },
          child: Text(
            "Keep Me Signed in",
            style: context.bodyExtraSmall,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            return Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  ref.read(rememberMeNotifier.notifier).state = !rememberMe;
                });
          },
        )
      ],
    );
  }
}
