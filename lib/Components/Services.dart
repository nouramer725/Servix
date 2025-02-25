import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ServicesRow extends StatelessWidget {
  final List<String> mainServices;
  final Map<String, List<String>> subServicesMap;
  final String? selectedMainService;
  final String? selectedSubService;
  final ValueChanged<String?> onMainChanged;
  final ValueChanged<String?> onSubChanged;
  final String? mainServiceError;
  final String? subServiceError;

  const ServicesRow({
    Key? key,
    required this.mainServices,
    required this.subServicesMap,
    required this.selectedMainService,
    required this.selectedSubService,
    required this.onMainChanged,
    required this.onSubChanged,
    this.mainServiceError,
    this.subServiceError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Main Service Dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedMainService,
                    hint: Text("Main Service".tr()),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    items: mainServices.map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      onMainChanged(newValue);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Sub Service Dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSubService,
                    hint: Text("Sub Service".tr()),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    items: (selectedMainService == null)
                        ? []
                        : subServicesMap[selectedMainService]!
                        .map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      onSubChanged(newValue);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        // Error message for Main Service
        if (mainServiceError != null) ...[
          const SizedBox(height: 5),
          Text(
            mainServiceError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        // Error message for Sub Service
        if (subServiceError != null) ...[
          const SizedBox(height: 5),
          Text(
            subServiceError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
