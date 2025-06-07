import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_spe_cialties_cubits/cubit/getallspecialties_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/Custom_buttom.dart';
import 'package:azrobot/core/widgets/custom_text_field.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:azrobot/features/auth/presentation/widgets/login_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../manager/cubits/get_all_city_cubit/getallcity_cubit.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? name, email, phone, password, confirmPassword;
    int? selectedCityId;
    int? selectedSpecialityId;

    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
            } else if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Sign Up successful!")),
              );
context.go(
  AppRouter.kOtpCodeView,
  extra: OtpArguments(email: email!, password: password!),
);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errMessage}')),
              );
            }
          },
        ),
        BlocListener<GetallspecialtiesCubit, SpecialtiesState>(
          listener: (context, state) {
            if (state is SpecialtiesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Error loading specialties: ${state.errMessage}')),
              );
            }
          },
        ),
        BlocListener<GetallcityCubit, GetallcityState>(
          listener: (context, state) {
            if (state is CityFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error loading Citys: ${state.errMessage}')),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is SignUpLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Text(
                        "Sign Up",
                        style: TextStyles.bold30w400.copyWith(
                          color: Color(0xff375e9f),
                        ),
                      ),
                      const SizedBox(height: 22),
                      HintTextAuth(hint: "Name"),
                      SizedBox(height: 6),
                      CustomTextField(
                        onSaved: (value) => name = value,
                        validator: (value) =>
                            value!.isEmpty ? "Name is required" : null,
                      ),
                      const SizedBox(height: 12),
                      HintTextAuth(hint: "Email"),
                      SizedBox(height: 6),
                      CustomTextField(
                        onSaved: (value) => email = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          } else if (!value.contains("@")) {
                            return "Please enter a valid email address";
                          } else if (!value.endsWith(".com")) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      HintTextAuth(hint: "Mobile"),
                      SizedBox(height: 6),
                      CustomTextField(
                        onSaved: (value) => phone = value,
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Mobile Number is required";
                        },
                      ),
                      const SizedBox(height: 12),
                      HintTextAuth(hint: "Main City"),
                      SizedBox(height: 6),
                    BlocBuilder<GetallcityCubit, GetallcityState>(
  builder: (context, state) {
    if (state is CitySuccess) {
      return DropdownButtonFormField<int>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 201, 199, 199),
            )
          ),
          border: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedCityId,
        items: state.citys.map((city) {
          return DropdownMenuItem<int>(
            value: int.parse(city['id'].toString()), // تحويل لـ int
            child: Text(city['name']),
          );
        }).toList(),
        onChanged: (value) {
          selectedCityId = value;
        },
        validator: (value) => value == null ? "Please select a city" : null,
      );
    } else if (state is CityFailure) {
      return Text('Error loading Cities');
    }
    return const SizedBox();
  },
),
                      const SizedBox(height: 12),
                      HintTextAuth(hint: "Speciality"),
                      SizedBox(height: 6),
                     BlocBuilder<GetallspecialtiesCubit, SpecialtiesState>(
  builder: (context, state) {
    if (state is SpecialtiesSuccess) {
      return DropdownButtonFormField<int>(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 201, 199, 199),
            )
          ),
          border: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedSpecialityId,
        items: state.specialties.map((specialty) {
          return DropdownMenuItem<int>(
            value: int.parse(specialty['id'].toString()),  // تحويل لـ int
            child: Text(specialty['name']),
          );
        }).toList(),
        onChanged: (value) {
          selectedSpecialityId = value;
        },
        validator: (value) => value == null ? "Please select a speciality" : null,
      );
    } else if (state is SpecialtiesFailure) {
      return Text('Error loading specialties');
    }
    return const SizedBox();
  },
),
                      const SizedBox(height: 12),
                      HintTextAuth(hint: "Password"),
                      SizedBox(height: 6),
                      CustomTextField(
                        active: true,
                        onSaved: (value) {
                          password = value;
                          confirmPassword = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Password is required";
                          if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      HintTextAuth(hint: "Confirm Password"),
                      SizedBox(height: 6),
                      CustomTextField(
                        active: true,
                        onSaved: (value) {
                          confirmPassword = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirm Password is required";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButtom(
                        issized: false,
                        text: "Sign Up",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            if (confirmPassword != password) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  content: Text("Passwords do not match"),
                                ),
                              );
                              return;
                            }
                          context.read<SignUpCubit>().registerUser(
  name: name!,
  email: email!,
  mobile: phone!,
  password: password!,
  confirmPassword: confirmPassword!,
  city: selectedCityId!,            // ✅ لا تستخدم .toString()
  specialty: selectedSpecialityId!,// ✅ لا تستخدم .toString()
);

                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      LoginText(
                        text: "Already have an account?  ",
                        textClick: "LogIn",
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kLoginView);
                        },
                      ),
                      SizedBox(
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}