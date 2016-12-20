/*
 * Requires jquery ui
 */
 
 
(function($){
	var $calroot;
    function selectCurrentWeek() {
        window.setTimeout(function () {
            var t = $calroot.find('.ui-datepicker-current-day a');//.addClass('ui-state-active');
			t= t.closest('tr');
			t.find('td>a').addClass('ui-state-active');//.parent().addClass('ui-state-active');
        }, 1);
		showPicker();
    }
	function onSelect(dateText, inst) { 
        selectdate = $(this).datepicker('getDate');
        startDate = new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay());
        endDate = new Date(selectdate.getFullYear(), selectdate.getMonth(), selectdate.getDate() - selectdate.getDay() + 6);
        var dateFormat = inst.settings.dateFormat || $.datepicker._defaults.dateFormat;
		$calroot.trigger('weekselected',{
			start:startDate,
			end:endDate,
			weekOf:startDate
		});
		showWeekTitle(selectdate);
        selectCurrentWeek();
    }
	var reqOpt = {
		onSelect:onSelect,
		showOtherMonths: true,
        selectOtherMonths: true
	};
    $.fn.weekpicker = function(options){
		var $this = this;
		$calroot = $this;
		
		$this.datepicker(reqOpt);
		//events
		$dprow = $this.find('.ui-datepicker');
		
		$dprow.on('mousemove','tr', function() { 
			$(this).find('td a').addClass('ui-state-hover'); 
		});
		$dprow.on('mouseleave','tr', function() { 
			$(this).find('td a').removeClass('ui-state-hover'); 
		});
	};
})(jQuery);