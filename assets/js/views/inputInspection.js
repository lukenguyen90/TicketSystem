var today = new Date();
today = today.getMonth()+1 + '/' + today.getDate() + '/' + today.getFullYear();
$('input[name=ins_date]').val(today);
// $('input[name=ins_date]').trigger('change');

['#select-td_reason', '#select-ss_reason', '#select-result'].map (function (select) {
	$(select + ' > option').each( function (idx, el) {
		$(el).text($(el).val());
	});
});

// $(document).on('change', '#ins_order', function (e){
// 	console.log('getting order infos...');

// 	$.ajax({
// 		type: "get",
// 		url: '/index.cfm/order.orderInfo',
// 		data: {type: 'order', value: $(this).val()},
// 		dataType: "JSON",
// 		success: function (data) {
// 			console.log('data fetching...');
// 			console.log(data.message);
// 			console.log(data.success);
// 			if (data.success) {
// 				// console.log(data.order_info[0][0]);
// 				$('#ins_supplier').html(data.order_info[0][0].supplier.replace(/::/g,'<br>'));
// 				$('#ins_customer').html(data.order_info[0][0].customer.replace(/::/g,'<br>'));

// 				// for(var i = 0; i < data.order_info[1]; i++) {
// 				// 	$('#select-ins_pos').append('<option value=""></option>');
// 				// };

// 				$.ajax({
// 					type: 'get',
// 					url: '/index.cfm/inspection.itemSpecs',
// 					data: {itemno: '02172-360-0'},
// 					dataType: 'JSON',
// 					success: function (data) {
// 						console.log('item fetching...');
// 						console.log(data);
// 					},
// 					error: function(xhr, err) {
// 						console.log(xhr.responseText);
// 						console.log(err);
// 					}
// 				});
// 			}
// 		},
// 		error: function(xhr, err) {
// 			console.log(xhr);
// 		}
// 	});
// });