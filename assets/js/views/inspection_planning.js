(function(){
  var app = angular.module('InspectionPlanning', []);
  app.controller("CL_Plans",['$scope','$http',function($scope,$http){
    $scope.plans = [];
    $http.get("/index.cfm/inspectionplanning.getAllPlan/").success(function(dataResponse){
    	$scope.plans = JSON.parse(dataResponse);
    	if($scope.plans.length > 0){
    		$('.dataTables_empty').addClass('hide');
    	}
    	
    	// alert(dataResponse);
    });
  }]);

  

})();

