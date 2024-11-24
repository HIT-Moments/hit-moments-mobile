import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/custom_dialog.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/example/home_view.dart';
import 'package:hit_moments/app/views/onboarding/onboarding_view.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/constants/assets.dart';
import '../../../custom/widgets/scale_on_tap_widget.dart';
import '../../../l10n/l10n.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isFullField = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = getEmail().trim();
    _passwordController.text = getPassWord().trim();
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      context.read<AuthProvider>().setData(true);
    } else {
      context.read<AuthProvider>().setData(false);
    }
  }

  void _updateButtonColor() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _isFullField = false;
      context.read<AuthProvider>().fullFieldLogin(false);
    } else {
      if (!_isFullField) {
        _isFullField = true;
        context.read<AuthProvider>().fullFieldLogin(true);
      }
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      form.validate();

      // Use 'listen: false' here to avoid rebuilding the widget
      await context.read<AuthProvider>().login(_emailController.text.trim(), _passwordController.text.trim(), context);

      // Also use 'listen: false' here
      if (context.read<AuthProvider>().loginStatus == ModuleStatus.success) {
        if(getIsFirstTime() == true){
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding()),
            ModalRoute.withName(AppRoutes.ONBOARDING),
          );
        }
        else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
              ModalRoute.withName(AppRoutes.MY_HOME));
        }

      } else if (context.read<AuthProvider>().loginStatus == ModuleStatus.fail) {
        _showError();
      }
    }
  }

  void _showError() {
    showCustomDialog(
      context,
      title: S.of(context).error,
      content: Text(
        S.of(context).loginError,
        style: AppTextStyles.of(context)
            .regular24
            .copyWith(color: AppColors.of(context).neutralColor12),
        textAlign: TextAlign.center,
      ),
      backgroundPositiveButton: AppColors.of(context).primaryColor10,
      textPositive: S.of(context).ok,
      onPressPositive: () {
        Navigator.of(context).pop();
      },
      colorTextPositive: AppColors.of(context).neutralColor12,
      hideNegativeButton: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(Assets.images.authPNG),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      S.of(context).loginNow,
                      style: AppTextStyles.of(context).regular32.copyWith(color: AppColors.of(context).neutralColor12),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor11),
                      ),
                      style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12),
                      validator: (value) => !value!.contains('@') ? S.of(context).invalidEmail : null,
                      onSaved: (newValue) => _emailController.text = newValue ?? "",
                      onChanged: (value) {
                        _updateButtonColor();
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: S.of(context).password,
                          hintStyle: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor11),
                          errorStyle: TextStyle(
                            color:
                                context.watch<AuthProvider>().loginStatus == ModuleStatus.success ? Colors.green : AppColors.of(context).primaryColor10,
                          ),
                          errorText: context.watch<AuthProvider>().loginSuccess,
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: context.watch<AuthProvider>().loginStatus == ModuleStatus.success
                                      ? AppColors.of(context).neutralColor9
                                      : AppColors.of(context).primaryColor10)),
                          suffixIconColor: AppColors.of(context).neutralColor9,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )),
                      style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12),
                      controller: _passwordController,
                      validator: (value) => value!.length < 2 ? S.of(context).passwordTooShort : null,
                      onSaved: (newValue) => _passwordController.text = newValue ?? "",
                      onChanged: (value) {
                        _updateButtonColor();
                      },
                      obscureText: _obscureText,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Row(
                children: [
                  Checkbox(
                    value: context.watch<AuthProvider>().isRemember,
                    onChanged: (value) {
                      context.read<AuthProvider>().changeRemember();
                    },
                    activeColor: Colors.black,
                  ),
                  Text(
                    S.of(context).saveLoginInfo,
                    style: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor11),
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 32.w, top: 32.h, right: 32.w),
                child: context.watch<AuthProvider>().isFullFieldLogin
                    ? ScaleOnTapWidget(
                        onTap: (isSelect) async {
                          await _submit();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.of(context).primaryColor10,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              boxShadow: [
                                BoxShadow(color: AppColors.of(context).neutralColor8, spreadRadius: 1.h, blurRadius: 2.h, offset: Offset(0, 4.h))
                              ]),
                          child: Text(
                            S.of(context).login,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).regular32.copyWith(color: AppColors.of(context).neutralColor1),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor7,
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                            boxShadow: [
                              BoxShadow(color: AppColors.of(context).neutralColor8, spreadRadius: 1.h, blurRadius: 2.h, offset: Offset(0, 4.h))
                            ]),
                        child: Text(
                          S.of(context).login,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.of(context).regular32.copyWith(color: AppColors.of(context).neutralColor11),
                        ),
                      )),
            SizedBox(
              height: 32.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.SIGNUP);
              },
              child: RichText(
                text: TextSpan(
                  text: S.of(context).noAccount,
                  style: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor11),
                  children: <TextSpan>[
                    TextSpan(
                      text: S.of(context).registerNow,
                      style: AppTextStyles.of(context).bold16.copyWith(color: AppColors.of(context).primaryColor10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
