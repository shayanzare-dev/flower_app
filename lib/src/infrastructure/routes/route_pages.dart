import 'package:flower_app/src/pages/login_page/commons/login_page_flower_bindings.dart';
import 'package:flower_app/src/pages/login_page/view/login_page_flower.dart';
import 'package:flower_app/src/pages/register_page/view/register_page_flower.dart';
import 'package:get/get.dart';
import '../../pages/customer_cart_page/commons/customer_cart_page_bindings.dart';
import '../../pages/customer_cart_page/view/customer_cart_page.dart';
import '../../pages/customer_history_page/commons/customer_history_page_bindings.dart';
import '../../pages/customer_history_page/view/customer_history_page.dart';
import '../../pages/customer_home_page/commons/customer_home_page_flower_bindings.dart';
import '../../pages/customer_home_page/view/customer_home_page_flower.dart';
import '../../pages/customer_profile_page/commons/customer_profile_page_bindings.dart';
import '../../pages/customer_profile_page/view/customer_profile_page.dart';
import '../../pages/customer_search_page/commons/customer_search_page_bindings.dart';
import '../../pages/customer_search_page/view/customer_search_page.dart';
import '../../pages/edit_flower_page/commons/edit_flower_page_bindings.dart';
import '../../pages/edit_flower_page/view/edit_flower_page.dart';
import '../../pages/loading_page/commons/loading_page_bindings.dart';
import '../../pages/loading_page/view/loading_page.dart';
import '../../pages/register_page/commons/register_page_flower_bindings.dart';
import '../../pages/vendor_add_flower_page/commons/vendor_add_flower_page_bindings.dart';
import '../../pages/vendor_add_flower_page/view/vendor_add_flower_page.dart';
import '../../pages/vendor_history_page/commons/vendor_history_page_bindings.dart';
import '../../pages/vendor_history_page/view/vendor_history_page.dart';
import '../../pages/vendor_home_page/commons/vendor_home_page_flower_bindings.dart';
import '../../pages/vendor_home_page/view/vendor_home_page_flower.dart';
import '../../pages/vendor_profile_page/commons/vendor_profile_page_bindings.dart';
import '../../pages/vendor_profile_page/view/vendor_profile_page.dart';
import '../../pages/vendor_search_page/commons/vendor_search_page_bindings.dart';
import '../../pages/vendor_search_page/view/vendor_search_page.dart';
import 'route_names.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(
      name: RouteNames.loadingPageFlower,
      page: () => const LoadingPage(),
      binding: LoadingPageBindings(),
    ),
    GetPage(
      name: RouteNames.loginPageFlower,
      page: () => LoginFormPage(),
      binding: LoginPageFlowerBindings(),
    ),
    GetPage(
        name: RouteNames.vendorHomePageFlower,
        page: () => VendorHomePageFlower(),
        binding: VendorHomePageFlowerBindings(),
        children: [
          GetPage(
            name: RouteNames.editFlowerPage,
            page: () => const EditFlowerPage(),
            binding: EditFlowerPageBindings(),
          ),
          GetPage(
            name: RouteNames.addFlowerPage,
            page: () => const VendorAddFlowerPage(),
            binding: VendorAddFlowerPageBindings(),
          ),
          GetPage(
            name: RouteNames.vendorHistoryPage,
            page: () => const VendorHistoryPage(),
            binding: VendorHistoryPageBindings(),
          ),
          GetPage(
            name: RouteNames.vendorSearchPage,
            page: () => const VendorSearchPage(),
            binding: VendorSearchPageBindings(),
          ),
          GetPage(
            name: RouteNames.vendorProfilePage,
            page: () => VendorProfilePage(),
            binding: VendorProfilePageBindings(),
          ),
        ]),
    GetPage(
        name: RouteNames.customerHomePageFlower,
        page: () => CustomerHomePageFlower(),
        binding: CustomerHomePageFlowerBindings(),
        children: [
          GetPage(
            name: RouteNames.customerCartPage,
            page: () => const CustomerCartFlowerPage(),
            binding: CustomerCartPageBindings(),
          ),
          GetPage(
            name: RouteNames.customerHistoryPage,
            page: () => const CustomerHistoryPage(),
            binding: CustomerHistoryPageBindings(),
          ),
          GetPage(
            name: RouteNames.customerProfilePage,
            page: () => CustomerProfilePage(),
            binding: CustomerProfilePageBindings(),
          ),
          GetPage(
            name: RouteNames.customerSearchPage,
            page: () => const CustomerSearchPage(),
            binding: CustomerSearchPageBindings(),
          ),
        ]),
    GetPage(
      name: RouteNames.registerPageFlower,
      page: () => const RegisterPageFlower(),
      binding: RegisterPageFlowerBindings(),
    ),
  ];
}
