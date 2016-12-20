// order info filling automatically

var today = new Date();
today = today.getMonth()+1 + '/' + today.getDate() + '/' + today.getFullYear();
$('input[name=order_date]').val(today);

$(document).on('input', 'input[list=listCusNumber]', function (e) {
	//console.log('triggering from gildemeister...');
	var $cus = $('#listCusName > option[cusgid="'+ $(this).val() +'"]');
	$('input[list=listCusName]').val($cus.val());
	$('textarea[placeholder="Customer\'s Address"]').html('').html($cus.attr('address'));
});

$(document).on('input', 'input[list=listCusName]', function (e) {
	//console.log('triggering from name...');
	var $cus = $('#listCusName > option[value="'+ $(this).val() +'"]');
	$('input[name=customer_gid]').val($cus.attr('cusgid'));
	$(this).parent().parent().next().next().find('textarea').html('').html($cus.attr('address'));
});

$(document).on('input', 'input[list=listSupNumber]', function (e) {

	var $sup = $('#listSupName > option[supgid="'+ $(this).val() +'"]');
	$('input[list=listSupName]').val($sup.val());
	$('textarea[placeholder="Supplier\'s Address"]').html('').html($sup.attr('address'));
});

$(document).on('input', 'input[list=listSupName]', function (e) {

	var $sup = $('#listSupName > option[value="'+ $(this).val() +'"]');
	$('input[name=supplier_gid]').val($sup.attr('supgid'));

	var $box = $(this).parent().parent().next().next();
	$box.find('textarea').html('').html($sup.attr('address'));
	['person','mail','phone','fax'].map(function(sup_attr) { 
		// console.log($sup.attr(sup_attr)); 
		$box = $box.next();
		$box.find('input').val($sup.attr(sup_attr));
	});
});

$(document).on('input', 'input[list=listItemNumber]', function (e) {

	var item_name = $('#listItem > option[id="'+ $(this).val() +'"]').val();
	$('input[list=listItem]').val(item_name);
	$('input[list=listItem]').trigger('change');
});

$(document).on('input', 'input[list=listItem]', function (e) {

	var input_item = $('#listItem > option[value="'+ $(this).val() +'"]').prop('id');
	$('input[name=item_no]').val(input_item);
	$(this).trigger('change');
});

$(document).on('change', 'input[list=listItem]', function (e) {
	if ( $(this).val().indexOf('::') > -1 ) {
		var item = $(this).val().split(' :: ');
		$(this).val(item[0]);
		$('#pattern_name').html(item[1]);
	} else {
		$('#pattern_name').html('<i>(of the chosen item)</i>');
	};
});
	
$(document).on('click', '#update_pos', function (e) {
	// *** updating pos	
	var pos_no = +$('input[name=pos_no]').val();
	var quantity = +$('input[name=order_quantity]').val();
	var price = +$('input[name=unit_price]').val();
	var item_no = $('input[name=item_no]').val();
	var etdate = $('input[name=eta]').val().replace(/-/g, '');
	var cddate = $('input[name=cdd]').val().replace(/-/g, '');

	if (item_no == '' || quantity == 0 || price == 0 || etdate == '') {
		$('#warning').html('Not enough information!');
		$('#modalWarn').modal('show');
		return;
	};

	var pos_data = '<td>'+ pos_no +'</td>';
	pos_data += '<td>'+ item_no + ' :: ' + $('input[list=listItem]').val() +'</td>';
	pos_data += '<td>'+ $('#pattern_name').text() +'</td>';
	pos_data += '<td>'+ quantity +'</td>';
	pos_data += '<td>'+ price +'</td>';
	pos_data += '<td>'+ (price * quantity) +'</td>';
	pos_data += '<td>'+ $('select[name=currency]').val() +'</td>';
	pos_data += '<td>'+ $('select[name=transport]').val() +'</td>';
	pos_data += '<td>'+ (etdate == '//' ? '' : etdate ) +'</td>';
	pos_data += '<td>'+ (cddate == '//' ? '' : cddate) +'</td>';
	pos_data += '<td><a class="txt-color-green" href="/index.cfm/inspection.inputInspection" title="Preview">\
					<i class="ace-icon bigger-130 fa fa-pencil"></i></a>\
				<a href=""  class="txt-color-red" title="Delete"><i class="ace-icon bigger-130 fa fa-trash-o"></i></a></td>';

	$('#order_item').append('<tr>' + pos_data + '</tr>');
	resetPosInfo();
	$('input[name=pos_no]').val(pos_no + 1);
});

$(document).on('click', '#refesh_pos', function(e) {
	var pos_no = +$('input[name=pos_no]').val();
	resetPosInfo();
	$('input[name=pos_no]').val(pos_no);
});

$(document).on('keypress', '#modalWarn', function (e) { 
	if (e.charCode == 13)	
		$('#modalWarn').modal('hide');
});

// end filling

// loading customer's members to be as a purchaser or a planner

$(document).on('change', 'input[list=listCusName]', function (e) {
	$('input[list=listCusNumber').trigger('change');
});

$(document).on('change', 'input[list=listCusNumber]', function (e) {
	console.log('member fetching...');
	$('#select-purchaser').empty().append('<option>Select a person</option>');
	$('#select-planner').empty().append('<option>Select a person</option>');

	$.ajax({
		type: "get", 
		url: "/index.cfm/order.companyMember",
		data: {gid: $(this).val()},
		dataType: "JSON",
		success: function(data) {
			console.log(data.DATA);
			var cus_member = [];
			if (data.DATA.length > 0) {
				$.each(data.DATA, function(idx, person) {
					cus_member.push('<option value="'+ person[0] +'">'+ person[1] +'</option>');
				});

				$('#select-purchaser').append(cus_member.join(''));
				$('#select-planner').append(cus_member.join(''));
				
			} else {
				// console.log('noone from there ~~~');
			};
		},
		error: function(error) {
			console.log(error);
		}
	});
});

// end loading

// saving new order

$(document).on('click', '#save_order', function (e) {
	console.log('saving new order...');

	console.log($('#order_information').serialize());

	// $.ajax({
	// 	type: "post",
	// 	url: "/index.cfm/order.saveOrder",
	// 	data: $('#order_information').serialize(),
	// 	dataType: "JSON",
	// 	success: function(data) {
	// 		if (data.success) {
	// 			alert('Thank you for the new order!');
	// 			location.href = '/index.cfm/order.oSearch';
	// 		} else {
	// 			console.log(data.message);
	// 			alert('Sorry for the error.\nWe\'re working on it.');
	// 			window.location.href = "/index.cfm/order.oSearch";
	// 		};
	// 	},
	// 	error: function(xhr, err) {
	// 		console.log(xhr.status);
	// 	}
	// });
});

// end saving

// pre-defined funcs

function resetPosInfo() {
	$('.position').find('input').each(function(idx, box) {
		$(box).val('');
	});
	$('#pattern_name').html('<i>(of the chosen item)</i>');
	$('select[name=currency]').val('VND');
	$('select[name=transport]').val('Air');
};