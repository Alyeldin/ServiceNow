app.controller(
  "prDetailsCtrl",
  function ($scope, $routeParams, productService) {
    $scope.productID = $routeParams.id;

    productService
      .getproductID($scope.productID)
      .then(function (response) {
        $scope.product = response.data[0];
      })
      .catch(function (error) {
        console.log("Error loading users", error);
      });
  },
);
