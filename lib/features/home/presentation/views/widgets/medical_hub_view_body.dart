import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/features/home/presentation/views/widgets/card_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/cubits/get_content_category/getcontentcategory_cubit.dart';

class MedicalHubViewBody extends StatefulWidget {
  const MedicalHubViewBody({super.key});

  @override
  State<MedicalHubViewBody> createState() => _MedicalHubViewBodyState();
}

class _MedicalHubViewBodyState extends State<MedicalHubViewBody> {
  @override
  void initState() {
    super.initState();
    // استدعاء المحتوى حسب الفئة (يمكن تغيير الرقم 2 حسب الفئة المطلوبة)
    context.read<GetContentByCategoryCubit>().getContentByCategory(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetContentByCategoryCubit, GetContentByCategoryState>(
      builder: (context, state) {
        if (state is GetContentByCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetContentByCategoryFailure) {
          return Center(child: Text('Error: ${state.errMessage}'));
        } else if (state is GetContentByCategorySuccess) {
          final contents =
              (state.data['contents']?['contents'] as List<dynamic>? ?? []);

          if (contents.isEmpty) {
            return const Center(child: Text('No content available'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final item = contents[index] as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        AppRouter.kMedicalHubDetailsView,
                        extra: item, // إرسال بيانات العنصر للصفحة التالية
                      );
                    },
                    child: CardHome(
                      numtop: 100,
                      image: item['image_url'] ?? Assets.assetshub,
                      title: item['title'] ?? 'No title',
                      discription: item['description'] ?? 'No description',
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox(); // الحالة الابتدائية
      },
    );
  }
}
