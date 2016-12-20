//1.handles week highligthing within week picker
//2.Handles placeholders, attr is removed when focusing an input
//3.Loading animation
//4.Multiselects now resize according to elements within
//5.Handle Export options dropdown

$(function(){



    //handle week highlighting within date picking options
    //Highlight all days within week that is being hovered, week datepicker has class: bootstrap-datetimepicker-widget-week, so this way
    //we can't target the other instances of datepickers currently in the view
    $('.bootstrap-datetimepicker-widget-week .datepicker-days tbody tr').live('mouseenter',function(){
        $(this).find('td.day').addClass('highlight-week-hover');
    })
    //When mouseleaving the weeek we need to remove the hover class, but make sure the highlight stays on the selected week
    //since we have a week selected by default
    $('.bootstrap-datetimepicker-widget-week .datepicker-days tbody tr').live('mouseleave',function(){
        ////remove the hover class from all days within the hovered week
        $(this).find('td.day').removeClass('highlight-week-hover');
        //but attach the highlight class to the active week so it doesnt get de-highlighted
        $(this).find('td.active').parent().find('td').addClass('highlight-week')
    })



    ///handle placeholders, they should be removed and re-aded if empty
    $('input[type="text"]').focus(function(){
        //placeholder = $(this).attr('placeholder');
        //$(this).removeAttr('placeholder');
        //$(this).attr('data-placeholder',placeholder);
    })

    $('input[type="text"]').blur(function(){
       // placeholder = $(this).attr('data-placeholder');
       // if($(this).val()=='')
        //{
        //    $(this).removeAttr('data-placeholder');
           // $(this).attr('placeholder',placeholder);
        //}
    })


    //handle sizing of dropdowns
    $('.multiselect-container').each(function()
    {
        resizeDropdown($(this));

    })

    function resizeDropdown(element){

        //height of search field
        searchHeight = 50;

        //position of the element from the top of the window + the height of the button
        topOffset = element.parent().offset().top+34;

        //calculate the total height of the dropdown
        totalHeight = element.find('li').length * 26 + searchHeight;

        //get the total window height - topoffset
        totalAvailableSpace = $(window).height()-topOffset;


        if(totalHeight > totalAvailableSpace)
        {
            element.css('max-height','');
            element.css('height',totalAvailableSpace-15+'px');
        }
        else if(totalHeight==52)
        {
            element.css('max-height','');
            element.css('height',totalHeight+'px');
        }
        else
        {
            element.css('max-height','');
            element.css('height',totalHeight+'px');
        }
    }

    ////we need to add window resize also in order to make this dropdown squeeze also when scree resizing
    $(window).resize(function(){
        $('.multiselect-container').each(function()
        {

            resizeDropdown($(this))
        })

    })

    //resize the dropdown when searching in the corresponding search inputs
    $('.multiselect-container').each(function() {
       var  multiContainer = $(this);
        $(this).find('.multiselect-search').keyup(function(){
            //add 1 second timeout for the search to finish before calculating
            setTimeout(function(){
                var totalHeight = multiContainer.find('li:visible').length * 26;
                totalWindowHeight = $(window).height();
                if(totalHeight > (totalWindowHeight-100))
                {
                    multiContainer.css('max-height','');
                    multiContainer.css('height',totalWindowHeight-100+'px');
                }
                else if(totalHeight==52)
                {

                    multiContainer.css('max-height','');
                    multiContainer.css('height',totalHeight+52+'px');
                }
                else
                {
                    multiContainer.css('max-height','');
                    multiContainer.css('height',totalHeight+52+'px');
                }
            },500);

        })
    })



})


function populateUserSelection(user_id){

    $.ajax({
        type: 'GET',
        url: '/api/users/'+user_id+'/managed?currentUser=first&showDeactivatedAsActivated=1',
        dataType: 'json',
        success: function(output) {
            if(output){
                $('.user-selection').html('');
                for(i=0; i<output.total; i++) 
                {
                    if(output.result[i].desktopLastLogin.date.substr(0, 20) == '-0001-11-30 00:00:00' && output.result[i].id != user_id)
                        continue;
                        
                    selected = (user_id == output.result[i].id) ? 'selected' : '' ;
                    myself = (user_id == output.result[i].id) ? ' (Myself)' : '' ;
                    $('.user-selection').append('<option value="'+output.result[i].id+'" '+ selected +'>'+output.result[i].fullname+myself+'</option>');
                }
            }
        },
        async: false
    });
}

function populatePayrollUserSelection(user_id){

    $.ajax({
        type: 'GET',
        url: '/api/users/'+user_id+'/payroll?currentUser=first&payrollUserStatus=active',
        dataType: 'json',
        success: function(output) {
            if(output){
                $('.user-selection').html('');
                for(i=0; i<output.total; i++) 
                {
                   if(output.result[i].desktopLastLogin.date.substr(0, 20) == '-0001-11-30 00:00:00')
                        continue;

                    if(output.result[i].active == 0 || output.result[i].value =='inactive')
                        continue;

                    selected = (user_id == output.result[i].id) ? 'selected' : '' ;
                    myself = (user_id == output.result[i].id) ? ' (Myself)' : '' ;
                    $('.user-selection').append('<option value="'+output.result[i].id+'" '+ selected +'>'+output.result[i].fullname+myself+'</option>');
                }
            }
        },
        async: false
    });
}

function setUsersSelected(usersSelected, reportType){
    $.post("content/reports/setUsersSelected.php",{ usersSelected:usersSelected, reportType:reportType } ,
        function(output){
        });
}

function getUsersSelected(element,reportType){
    $.ajax({
        type: 'POST',
        url: 'content/reports/getUsersSelected.php',
        dataType: 'json',
        success: function(output) {
            if(output){
                $(element).val(output);
               //console.log(output);
            }
        },
        data: {reportType:reportType},
        async: false
    });
}

//////////LOADING ANIMATION
function show_loading(element_id, loading_type, loading_message, path)
{
    //alert(element_id);
    if(loading_message=='')
    {
        loading_message = 'Loading data. Please wait...';
    }

    var load_image = true;
    if (path === false) {
        load_image = false;
    }
    else if(typeof path == 'undefined')
    {
        path = '';
    }
    //define animations
    if(load_image)
    {
        loading_animation = '<img src="' + path + '/v2/views/images/reports/loading-16x16.gif" class="loadingAnimation"/>';
        console.log(path);
        console.log(loading_animation);
        loading_animation2 = '<img src="' + path + 'views/images/reports/loading-32x32.gif" class="loadingAnimation"/>';
    }
    else
    {
        loading_animation = '';
    }

    switch (loading_type)
    {
        ///shows loading within element
        case 'inline':
            render_loading = '<div class="tdLoadingInline">' + loading_animation + '</div>';
            $(element_id).html(render_loading);
            break;

        ///shows loading message out of the elements flow
        case 'overlay':
            render_loading = '<div class="tdLoadingOverlay">' + loading_animation + loading_message + '</div>';
            $('body').append(render_loading);
            break;
    }
}

//////////REMOVE LOADING ANIMATION
function remove_loading(miliseconds)
{
    if(miliseconds!='undefined')
    {
        ///set timeout
        setTimeout(function()
        {
            $('.tdLoadingInline').fadeOut(500);
            $('.tdLoadingOverlay').fadeOut(500);
            $('.tdLoadingInline').remove();
            $('.tdLoadingOverlay').remove();
        }, miliseconds);
    }
    else
    {
        ///just remove both types from flow
        $('.tdLoadingInline').remove();
        $('.loadingMessageOverlay').remove();
    }
}



$(function(){
    ///handle export dropdown options
    var timeout = 0;
    var hovering = false;

    ///activeExport is the active class we assign to a.exportLinkOptions
    $('.exportDropdown').fadeOut();

    $('a.exportLinkOptions')
        .mouseenter(function ()
        {
            ///reset flag
            hovering = true;
            /// Open the Dropdown Menu
            $('.exportDropdown').stop(true, true).fadeIn();
        })
        .mouseleave(function () {
            ///the timeout is needed incase of going to the dropdown menu
            resetHover();
        });

    $(".exportDropdown")
        .mouseenter(function () {
            ///reset flag
            hovering = true;
        })
        .mouseleave(function () {
            ///The timeout is needed incase of going back to export options
            resetHover();
        });

    function resetHover() {
        ///allow the menu to close if the flag isn't set by another event
        hovering = false;
        ///set the timeout
        timeout = setTimeout(function () {
            checkHover();
        },400)
    }

    function checkHover() {
        ///only close if not hovering
        if (!hovering) {
            closeDropdown();
        }
    }

    function closeDropdown() {
        ///closes the Dropdown
        $('.exportDropdown').stop(true, true).fadeOut();
    }
})