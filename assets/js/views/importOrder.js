
function parseDataFromFile(filename){
	// alert(filename);
	$.ajax({
	        type: "POST",
	        url: "/index.cfm/import.parseDataFromFile/",
	        data: {
	        	filename:filename
	        	},
	        dataType: "JSON",
	        success: function (dataReturn) {
	        	// window.location.href=window.location.href
	        	var scope = angular.element($('#StoreControllerID')).scope();
	        	scope.setProduct(JSON.parse(dataReturn));
	        	scope.$apply();
	        },
		});
}

(function(){
  var gem = { name: 'Azurite', price: 2.95 };
  var app = angular.module('gemStore', []);
  app.controller("StoreController",['$scope',function($scope){
    $scope.product = [];
    $scope.setProduct = function(data){
    	console.log(data);
    	$scope.product = data;
    };
  }]);

})();


