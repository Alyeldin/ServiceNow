// CONTROLLER: Handles UI Logic
app.controller("productCtrl", function ($scope, ProductService) {
  $scope.products = [];
  $scope.newProduct = {};
  $scope.isLoading = true;

  // Fetch Data
  $scope.load = function () {
    $scope.isLoading = true;
    ProductService.getProducts()
      .then(function (res) {
        $scope.products = res.data;
      })
      .finally(function () {
        $scope.isLoading = false;
      });
  };

  // Add Product
  $scope.addProduct = function () {
    $scope.isPosting = true;
    ProductService.saveProduct($scope.newProduct)
      .then(function (res) {
        $scope.products.unshift(res.data);
        $scope.newProduct = {};
        Swal.fire({
          icon: "success",
          title: "Added!",
          text: "Product added successfully",
          timer: 2000,
          showConfirmButton: false,
        });
      })
      .finally(function () {
        $scope.isPosting = false;
      });
  };

  // Update Product
  $scope.saveUpdate = function (product) {
    ProductService.updateProduct(product.id, product).then(function () {
      product.isEditing = false;
      Swal.fire({
        icon: "success",
        title: "Updated!",
        text: "Product info saved",
        timer: 1500,
        showConfirmButton: false,
      });
    });
  };

  // Delete Product (With SweetAlert Confirmation)
  $scope.removeProduct = function (id, index) {
    Swal.fire({
      title: "Are you sure?",
      text: "This product will be removed permanently!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#6e7881",
      confirmButtonText: "Yes, delete it!",
    }).then((result) => {
      if (result.isConfirmed) {
        ProductService.deleteProduct(id).then(function () {
          $scope.products.splice(index, 1);
          Swal.fire("Deleted!", "Product has been removed.", "success");
        });
      }
    });
  };

  $scope.editProduct = function (p) {
    p.isEditing = true;
  };
  $scope.cancelEdit = function (p) {
    p.isEditing = false;
  };

  $scope.load();
});
