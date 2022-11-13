import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/home/home.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/floating_action_button.dart';

import 'all_modules.dart';

class SelectModulesView extends StatefulWidget {
  final bool isOnboarding; // false when first creating account

  const SelectModulesView({
    Key? key,
    required this.isOnboarding,
  }) : super(key: key);

  @override
  State<SelectModulesView> createState() => _SelectModulesViewState();
}

class _SelectModulesViewState extends State<SelectModulesView> {
  final _currentUser = Get.find<AuthService>().currentUser;

  final searchController = TextEditingController();

  final List<String> selected = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selected.addAll(_currentUser.modules);
    searchController.addListener(() {
      setState(() {});
    });
  }

  void _onSubmit() async {
    setState(() => loading = true);
    _currentUser.modules = selected;
    await Get.find<UsersDbService>().updateUser(
      _currentUser.id,
      {'modules': selected},
    );
    setState(() => loading = false);
    if (widget.isOnboarding) {
      Get.off(HomeView());
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isOnboarding ? null : MyAppBar(title: 'Edit your modules'),
      floatingActionButton: MyFloatingActionButton(
        icon: Icons.check,
        loading: loading,
        onPressed: _onSubmit,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // show title text instead of appbar
            if (widget.isOnboarding)
              SizedBox(height: 36 + Get.mediaQuery.padding.top),
            if (widget.isOnboarding)
              Center(
                child: Text(
                  'Select your modules',
                  style: TextStyle(
                    color: Palette.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (widget.isOnboarding)
              SizedBox(height: 36)
            else
              SizedBox(height: 20),
            _buildSearchField(),
            SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    itemCount: sortedModules.length,
                    itemBuilder: (context, i) {
                      final category = sortedModules.keys.elementAt(i);
                      final moduleCodes = sortedModules[category]!;
                      return _buildCategory(category, moduleCodes);
                    },
                  ),
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Palette.black,
                          Palette.black.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Palette.black1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(width: 24),
          Icon(
            Icons.search,
            size: 20,
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: searchController,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              cursorColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Column _buildCategory(String category, List<String> moduleCodes) {
    if (searchController.text.isNotEmpty) {
      moduleCodes = moduleCodes
          .where((code) => code.contains(searchController.text.toUpperCase()))
          .toList();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2,
          ),
          itemCount: moduleCodes.length,
          itemBuilder: (context, i) {
            return _buildModuleCard(moduleCodes[i]);
          },
        ),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildModuleCard(String moduleCode) {
    final isSelected = selected.contains(moduleCode);
    return DefaultFeedback(
      onPressed: () {
        setState(() {
          if (selected.contains(moduleCode)) {
            selected.remove(moduleCode);
          } else {
            selected.add(moduleCode);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary : Palette.black1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            moduleCode,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
