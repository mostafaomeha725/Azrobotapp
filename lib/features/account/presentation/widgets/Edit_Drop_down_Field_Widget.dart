import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_city_cubit/getallcity_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_spe_cialties_cubits/cubit/getallspecialties_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditDrodownFieldWidget extends StatefulWidget {
  final String title;
  final String text;
  final bool isdropdown;
  final bool iscity;
  final ValueChanged<int?> onChanged;

  const EditDrodownFieldWidget({
    super.key,
    required this.title,
    required this.text,
    required this.onChanged,
    this.isdropdown = true,
    this.iscity = true,
  });

  @override
  State<EditDrodownFieldWidget> createState() => _EditDrodownFieldWidgetState();
}

class _EditDrodownFieldWidgetState extends State<EditDrodownFieldWidget> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child:  Text(widget.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1752A8),
              )),
          ),
          const SizedBox(height: 8),
          widget.iscity
              ? BlocBuilder<GetallcityCubit, GetallcityState>(
                  builder: (context, state) {
                    if (state is CitySuccess) {
                      final List<Map<String, dynamic>> cities =
                          List<Map<String, dynamic>>.from(state.citys);

                      selectedId ??= cities.firstWhere(
                        (city) => city['name'] == widget.title,
                        orElse: () => {},
                      )['id'];

                      return _buildDropdown(
                        items: cities,
                        selectedId: selectedId,
                        onChanged: (val) {
                          setState(() => selectedId = val);
                          widget.onChanged(val);
                        },
                      );
                    }
                    return _handleLoadingState(state);
                  },
                )
              : BlocBuilder<GetallspecialtiesCubit, SpecialtiesState>(
                  builder: (context, state) {
                    if (state is SpecialtiesSuccess) {
                      final List<Map<String, dynamic>> specialties =
                          List<Map<String, dynamic>>.from(state.specialties);

                      selectedId ??= specialties.firstWhere(
                        (sp) => sp['name'] == widget.title,
                        orElse: () => {},
                      )['id'];

                      return _buildDropdown(
                        items: specialties,
                        selectedId: selectedId,
                        onChanged: (val) {
                          setState(() => selectedId = val);
                          widget.onChanged(val);
                        },
                      );
                    }
                    return _handleLoadingState(state);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required List<Map<String, dynamic>> items,
    required int? selectedId,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 201, 199, 199)),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map<DropdownMenuItem<int>>((item) {
        return DropdownMenuItem<int>(
          value: int.tryParse(item['id'].toString()),
          child: Text(item['name']),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _handleLoadingState(Object state) {
    if (state is CityFailure || state is SpecialtiesFailure) {
      return const Text('حدث خطأ أثناء التحميل');
    }
    return const SizedBox();
  }
}
