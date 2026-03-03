var app = angular.module("myApp", ["ngRoute"]);

// app.controller("myCtrl", function ($scope) {});

app.config(function ($routeProvider) {
  $routeProvider
    .when("/products", {
      templateUrl: "views/products.html",
    })
    .when("/about", {
      templateUrl: "views/about.html",
    })

    .otherwise({
      redirectTo: "/products",
    });
});
