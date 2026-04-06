// SERVICE: Handles all HTTP communication
app.service("ProductService", function ($http) {
  var apiLink = "https://fakestoreapi.com/products";
  this.getProducts = function () {
    return $http.get(apiLink);
  };
  this.saveProduct = function (p) {
    return $http.post(apiLink, p);
  };
  this.updateProduct = function (id, p) {
    return $http.put(apiLink + "/" + id, p);
  };
  this.getproductID = function (id) {
    return $http.get(apiLink + "/" + id);
  };
  this.deleteProduct = function (id) {
    return $http.delete(apiLink + "/" + id);
  };
});
