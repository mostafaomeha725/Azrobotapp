import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_all_content/cubit/get_all_contents_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class VideoViewBody extends StatelessWidget {
  const VideoViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<GetAllContentsCubit, GetAllContentsState>(
        builder: (context, state) {
          if (state is GetAllContentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetAllContentsFailure) {
            return Center(child: Text('Error: ${state.errMessage}'));
          } else if (state is GetAllContentsSuccess) {
            // Debug print to verify data
            debugPrint('Contents: ${state.contents}');

            // Filter only video contents
            final videoContents = state.contents.where((content) {
              final category = content['category'] as Map<String, dynamic>?;
              return category != null && 
                     category['name'] == 'Videos' &&
                     content['video'] != null;
            }).toList();

            if (videoContents.isEmpty) {
              return const Center(child: Text("No videos available."));
            }

            return ListView.builder(
              itemCount: videoContents.length,
              itemBuilder: (context, index) {
                final content = videoContents[index];
                final imageUrl = content['image_url']?.toString() ?? '';
                final title = content['title']?.toString() ?? 'No Title';
                final videoUrl = content['video']?.toString() ?? '';

                debugPrint('Video Content: $content');

                return GestureDetector(
                  onTap: () {
                    if (videoUrl.isNotEmpty) {
                      GoRouter.of(context).push(
                        AppRouter.kVideoDetailsView, 
                        extra: content,
                      );
                    }
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  // ignore: deprecated_member_use
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (videoUrl.isNotEmpty)
                          const Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}