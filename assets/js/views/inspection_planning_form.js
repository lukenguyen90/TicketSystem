(function(){
  var app2 = angular.module('InspectionPlanningEdit', []);
  app2.controller("CL_PlanDetails",['$scope',function($scope){
    // $scope.planDetails = [];
    $scope.plan = '';
  	var idPlanUrl = getUrlParameter("id");
  	var planid = 0;
  	if(idPlanUrl != undefined){
		planid = idPlanUrl;
  	}
    $.ajax({
	        type: "POST",
	        url: "/index.cfm/inspectionplanning.getPlan/",
	        data: {
	        	planid:planid
	        	},
	        dataType: "JSON",
	        success: function (dataReturn) {
	        	$scope.plan = JSON.parse(dataReturn);
	        	// window.location.href=window.location.href
	        	// var scope = angular.element($('#StoreControllerID')).scope();
	        	// scope.setProduct(JSON.parse(dataReturn));
	        	$scope.$apply();
	        },
		});


  }]);

})();


var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};


