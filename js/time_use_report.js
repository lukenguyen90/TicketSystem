// JavaScript Document
$(document).ready(function()
{
 
    var currentAjax;
    populateUserSelection($('#loggedUser').val());
    getUsersSelected('.multiselect',"time_use_report");
    prevSelection = $('.multiselect').val();

    ///////render the table with default values
    daily_details_table();
    //////TOOLTIPS////////////////////////////////////
    $('.absence').tooltip();
    $('.td-tooltip').tooltip();
    $('.showTooltip').tooltip();
	
    //////////////////////////////////////////////////
    $('.multiselect').multiselect({enableCaseInsensitiveFiltering: true, includeSelectAllOption: true, enableFiltering: true, buttonWidth: 'auto', buttonClass: 'btn selectUser', maxHeight: 200, numberDisplayed: 1,
        onChange: function (option, checked) {
        },
        onDropdownHide: function()
        {
            this.setUsersSelectedToDB("time_use_report");
            if(!$('.multiselect').val()) {
                $('#loadReport').html('<div class="td-no-users-selected"><img src="views/images/reports/info_no_users_icon.png">Please select at least one user from the drop-down menu above.</div>');
                prevSelection = '';
                return '';
            }

            currentSelection = '' + $('.multiselect').val();
            prevSelection = '' + prevSelection;

            if(prevSelection == currentSelection) {
                return '';
            }

            prevSelection = $('.multiselect').val();
            daily_details_table();

        },
        buttonText: function(options) {
            count = 0;
            $('option', $('.multiselect')).each(function(element) {
                count++;
            });
            if (options.length == 0) {
                return 'No Users selected <b class="caret"></b>';
            }
            else if (count - options.length == 1 && options.length >1){
                return 'All ' + options.length + ' Users Selected <b class="caret"></b>';
            }
            else if (options.length > 1) {
                return options.length + ' Users Selected <b class="caret"></b>';
            }
            else{
                var selected = '';
                options.each(function() {
                    selected += $(this).text() + ', ';
                });
                return selected.substr(0, selected.length -2) + ' <b class="caret"></b>';
            }
        },
        buttonTitle: function (options, select) {
            var selected = '';
            var currentRow = '';
            options.each(function () {
                currentRow = $(this).text();
                currentRow = currentRow.trim();
                selected += currentRow + ', ';
            });
            return selected.substr(0, selected.length - 2);
            //  return '';
        }
    });

    ///initialize the datepickers
    CustomDate.showHidePickers();
    CustomDate.dateSelector('#date-day', function(value){
        //define your own call back functionality with return value
        daily_details_table();
    });
    CustomDate.weekSelector('#date-week', function(start, end){
        //define your own call back functionality with return value
        daily_details_table();
    });

    CustomDate.monthSelector('#date-month', function(value){
        //define your own call back functionality with return value
        daily_details_table();
    });

    CustomDate.dateRangeSelector('#date-range', function(start,end){
        //define your own call back functionality with return value
        daily_details_table();
    });

    $('#dayBtn').click(function() {
        $('#reportType').val('daily');
        daily_details_table();
    });

    $('#weekBtn').click(function() {
	    $(".timeUseTotal").css({ 'margin-top': '0px !important' });  
		$('#reportType').val('weekly');
        daily_details_table();
    });

    $('#monthBtn').click(function() {
		$('.timeUseTotal').css("marginTop","0px !important");
        $('#reportType').val('monthly');
        daily_details_table();
    });

    $('#dateRangeBtn').click(function() {
        $('#reportType').val('dateRange');
    });

    $('.applyBtn').click(function () {
        $('#reportType').val('dateRange');
        daily_details_table();
    });

    $('a.doAction').live('click', function () {

        var exportType = '';
        var action = '';

        action = $(this).attr('rel');
        //parse rel to get exportType and reportType properly
        exportType = action.substr(action.length - 3, action.length - 1);
        action = action.substr(0, action.length - 4);

        $('#exportType').val(exportType);
        $('#action').val(action);
        daily_details_table();

        return false;
    });
   //hide user select because of type user
    if ($('#loggedUserType').val()==='user') {
        $('.btnSelectUser').hide();
        $('.page-title').addClass('no-float');
        $('.btnGroupLinks').addClass('btnGroupLinks-user');
    }

});

function assignValues() {

    $('#userId').val($('.multiselect').val());
    switch($('#reportType').val()) {
        case 'daily':
            var tempDate = new Date($('.date-val').html());
            var curr_month = tempDate.getMonth() + 1;
            $("#fromDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            $("#toDate").val($("#fromDate").val());
            break;
        case 'weekly':
            var tempDate = new Date($('.st_week').html());
            var curr_month = tempDate.getMonth() + 1;
            $("#fromDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            tempDate = new Date($('.en_week').html());
            curr_month = tempDate.getMonth() + 1;
            $("#toDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            break;
        case 'monthly':
            var tmpStr = $('.month-val').html().split(',');
            var month = new Date(tmpStr[0] + ' 01,' + tmpStr[1]);
            var tempDate = new Date(month.getFullYear(), month.getMonth(), 1);
            var curr_month = tempDate.getMonth() + 1;
            $("#fromDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            tempDate = new Date(month.getFullYear(), month.getMonth() + 1, 0);
            curr_month = tempDate.getMonth() + 1;
            $("#toDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            break;
        default:
            var tempDate = new Date($('#start_date').html());
            var curr_month = tempDate.getMonth() + 1;
            $("#fromDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            tempDate = new Date($('#end_date').html());
            curr_month = tempDate.getMonth() + 1;
            $("#toDate").val(tempDate.getFullYear() + '-' + curr_month + '-' + tempDate.getDate() );
            break;
    }
    return;
}

/////////////////ALL FORM DATA IS SERIALIZED, JUST RENDER THE TABLE in the ajax outout
function daily_details_table() {

    if (!$('.multiselect').val()) {
        $('#loadReport').html('<div class="td-no-users-selected"><img class = "no_users_img" src="views/images/reports/info_no_users_icon.png">Please select at least one user from the drop-down menu above.</div>');
        return false;
    }
    if ($('.multiselect').val()[0] && $('.multiselect').val()[0] == "multiselect-all" && !$('.multiselect').val()[1]) {
        $('#loadReport').html('<div class="td-no-users-selected"><img class = "no_users_img" src="views/images/reports/info_no_users_icon.png">Please select at least one user from the drop-down menu above.</div>');
        return false;
    }

    assignValues();

    ////serialize form and ajax
    data = $('#filters_dayly').serialize();
    show_loading('#loading', 'overlay', 'Loading...');
    $('#loadReport').css('opacity', '.6');

    if (jQuery.type(window.currentAjax) == 'object'){
        window.currentAjax.abort();
    }
    if ($('#action').val() == 'render_table'){
        window.currentAjax = $.post("content/reports/timeUse/getTimeUseReportData.php", data,
            function (output) {
	    		if (output == ""){
	    			window.location = "/v2/logout.php";
	    		}
                $('#loadReport').html(output);
                $(".td-tooltip").tooltip();
                $('#loadReport').css('opacity', '1');
                remove_loading();
            });

        $('#action').val('export_consolidated');
        $('#exportType').val('for_printing');
        data = $('#filters_dayly').serialize();
        $.post("content/reports/timeUse/getTimeUseReportData.php", data,
            function (output2) {
                $('#for_printing').html(output2);
                $('#action').val('render_table');
            });
    } else if ($('#exportType').val() == 'prt'){
        $('#filters_dayly').attr('target', '_blank');
        $('#filters_dayly').attr('action', 'content/reports/timeUse/getTimeUseReportData.php');
        $('#filters_dayly').submit();
        $(".td-tooltip").tooltip();
        $('#loadReport').css('opacity', '1');
        $('#filters_dayly').removeAttr('target');
        remove_loading();
    } else {
        $('#filters_dayly').attr('action', 'content/reports/timeUse/getTimeUseReportData.php');
        $('#filters_dayly').submit();
        $(".td-tooltip").tooltip();
        $('#loadReport').css('opacity', '1');
        remove_loading();
    }
    //reset the action to render_table
    $('#action').val('render_table');
    $('#userId').val($('.multiselect').val());
}


