String baseUrl = "http://192.168.56.1:3000";
String imageUrl = "$baseUrl/img/product";

// Authentication
String register = "$baseUrl/users/register";
String login = "$baseUrl/users/login";
String getUsers = "$baseUrl/users/get";
String getTotalUsers = "$baseUrl/users/total-users";

// Brands
String getBrands = "$baseUrl/brand/get";
String inputBrand = "$baseUrl/brand/insert";
String updateBrand = "$baseUrl/brand/edit";
String deleteBrand = "$baseUrl/brand/delete";
String getTotalBrand = "$baseUrl/brand/total-brands";

// Categories
String getCategories = "$baseUrl/category/get";
String inputCategory = "$baseUrl/category/insert";
String updateCategory = "$baseUrl/category/edit";
String deleteCategory = "$baseUrl/category/delete";

// Transactions
String getTransactions = "$baseUrl/transaction/get";
String inputTransaction = "$baseUrl/transaction/insert";
String updateTransaction = "$baseUrl/transaction/edit";
String deleteTransaction = "$baseUrl/transaction/delete";
String getByUserIdTransaction = "$baseUrl/transaction/get-user";
String getTotalTransaction = "$baseUrl/transaction/total-transactions";
String highestTransactions = "$baseUrl/transaction/highest";

// Product
String getProducts = "$baseUrl/product/get";
String inputProduct = "$baseUrl/product/insert";
String updateProduct = "$baseUrl/product/edit";
String deleteProduct = "$baseUrl/product/delete";
String getTotalProduct = "$baseUrl/product/total-products";
String getProductByCategory = "$baseUrl/product/get-category/:category";
