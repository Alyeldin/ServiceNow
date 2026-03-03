var app = angular.module("myApp", ["ngRoute"]);

// app.controller("myCtrl", function ($scope) {});

app.config(function ($routeProvider) {
  $routeProvider
    .when("/products", {
      templateUrl: "views/products.html",
      controller: "productCtrl",
    })
    .when("/about", {
      templateUrl: "views/about.html",
    })
    .when("/prDetails/:id", {
      templateUrl: "views/prDetails.html",
      controller: "prDetailsCtrl",
    })
    .otherwise({
      redirectTo: "/products",
    });
});
