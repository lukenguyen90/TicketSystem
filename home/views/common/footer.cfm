<cfoutput>
  <div class="footer">
      <div class="footer-inner">
        <div class="footer-content">
          <span>
              Rasia System #getLabel("Management", #SESSION.languageId#)#
          </span>
          <span class="glyphicon glyphicon-registration-mark"> 2014
          </span>
        </div>
      </div>
  </div>  



  <a  id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
        <i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
      </a>
    </div><!-- /.main-container -->
    <script type="text/javascript">
      var uId = #SESSION.userID#;
    </script>
</cfoutput>
    <!-- basic scripts -->

    <!--[if !IE]> -->
    <script type="text/javascript">
      window.jQuery || document.write("<script src='/ACEAdmin/assets/js/jquery.min.js'>"+"<"+"/script>");
    </script>

    <!-- <![endif]-->

    <!--[if IE]>
<script type="text/javascript">
 window.jQuery || document.write("<script src='../assets/js/jquery1x.min.js'>"+"<"+"/script>");
</script>
<![endif]-->
    <script type="text/javascript">
      if('ontouchstart' in document.documentElement) document.write("<script src='/ACEAdmin/assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
    </script>
    <script src="/ACEAdmin/assets/js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->
    <script src="/ACEAdmin/assets/js/jquery-ui.custom.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/ACEAdmin/assets/js/fuelux/fuelux.spinner.min.js"></script>
    <script src="/ACEAdmin/assets/js/chosen.jquery.min.js"></script>
    <script src="/ACEAdmin/assets/js/jqGrid/jquery.jqGrid.min.js"></script>
    <script src="/ACEAdmin/assets/js/jqGrid/i18n/grid.locale-en.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.hotkeys.min.js"></script>
    <script src="/ACEAdmin/assets/js/bootstrap-wysiwyg.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.validate.min.js"></script>
    <script src="/ACEAdmin/assets/js/additional-methods.min.js"></script>
    <script src="/ACEAdmin/assets/js/bootbox.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.knob.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.autosize.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.maskedinput.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
    <script src="/ACEAdmin/assets/js/select2.min.js"></script>
    <script src="/ACEAdmin/assets/js/bootstrap-tag.min.js"></script>
    <script src="/ACEAdmin/assets/js/bootstrap-colorpicker.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery-ui.min.js"></script>
    <script src="/ACEAdmin/assets/js/date-time/moment.min.js"></script>
    <script src="/ACEAdmin/assets/js/date-time/bootstrap-datepicker.min.js"></script>
    <script src="/ACEAdmin/assets/js/date-time/daterangepicker.min.js"></script>
    <!-- ace scripts -->
    <script src="/ACEAdmin/assets/js/ace-elements.min.js"></script>
    <script src="/ACEAdmin/assets/js/ace.min.js"></script>
    <!--- hightchart --->
    <script src="/ACEAdmin/assets/js/hightchart/highcharts.js"></script>
    <script src="/ACEAdmin/assets/js/hightchart/highcharts-3d.js"></script>
    <script src="/ACEAdmin/assets/js/hightchart/modules/drilldown.js"></script>
    <script src="/ACEAdmin/assets/js/hightchart/modules/data.js"></script>
    <script src="/ACEAdmin/assets/js/hightchart/modules/exporting.js"></script>
    <!--- Calendar --->
    <script src="/ACEAdmin/assets/js/jquery-ui.custom.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.ui.touch-punch.min.js"></script>
    <script src="/ACEAdmin/assets/js/fullcalendar.min.js"></script>
    <script src="/ACEAdmin/assets/js/bootbox.min.js"></script>


    <script src="/js/jquery.playsound.js"></script>
    <script src="/js/jquery.dataTables.columnFilter.js"></script>
    <script src="/ACEAdmin/assets/js/date-time/bootstrap-timepicker.min.js"></script>

    <!-- inline scripts related to this page -->
<cfoutput>
  <cfif SESSION.userType gt 1>
    <script type="text/javascript">
    var notification = null ;
    var nMess = '';
    // request permission on page load
      document.addEventListener('DOMContentLoaded', function () {
        if (Notification.permission !== "granted")
          Notification.requestPermission();
      });

      function notifyMe() {
        // $.playSound('/tone');
        if (!Notification) {
          alert('Desktop notifications not available in your browser. Try Chromium.'); 
          return;
        }

        if (Notification.permission !== "granted")
          Notification.requestPermission();
        else {
          var mess = nMess == '' ? 'What are you doing?' : nMess;
          var notification = new Notification(mess, {
            icon: 'http://cdn.sstatic.net/stackexchange/img/logos/so/so-icon.png',
            body: "Hey there! Are you working ?",
          });

          notification.onclick = function () {
            stopNotification();
          };
          
        }

      }
      function stopNotification(){
            // clearTimeout(notification);
            // notification = null ;
            <cfif rc.action != 'home:main.todo'>
              window.location.href = '/index.cfm/main/todo';
            </cfif>
      }
      var upTimeDisPlay = setInterval(function () {updateTrackerTimeDisplay()}, 1000);
      function updateTrackerTimeDisplay(){
        if(typeof(localStorage.updateTime#SESSION.userID#) !== 'undefined'){
          if(parseInt(localStorage.isPause#SESSION.userID#) == 0){
            var date1 =new Date(localStorage.updateTime#SESSION.userID#);
            var date1_ms = date1.getTime();
            var date2 = new Date();
            var date2_ms = date2.getTime();
            localStorage.updateTime#SESSION.userID# = new Date();
            var ms = parseInt((date2_ms - date1_ms)/1000) ;
            if(localStorage.tracker#SESSION.userID# !== ''){
              // console.log(localStorage);
              var h = parseInt(localStorage.h#SESSION.userID#);
              var n = parseInt(localStorage.n#SESSION.userID#);
              var s = parseInt(localStorage.s#SESSION.userID#);
                // if(s === NaN)s=0;
                // console.log(s);
                s = s + ms ;
                if(s >= 60 ){
                  n = parseInt(n + s/60) ;
                  s = s % 60;
                  if(n >= 60){
                    h = parseInt(h + n/60);
                    n = n%60;
                  }
                }
                var sVal = (h < 10 ? '0'+ h : h)+':'+(n < 10 ? '0'+ n : n);
                var sVal1 = (h < 10 ? '0'+ h : h)+':'+(n < 10 ? '0'+ n : n)+':'+(s < 10 ? '0'+ s : s);
                localStorage.h#SESSION.userID# = h;
                localStorage.n#SESSION.userID# = n;
                localStorage.s#SESSION.userID# = s;
                // console.log(localStorage.s#SESSION.userID#);
                $('##tracker-header').text(localStorage.ticketCode#SESSION.userID#).attr('title',localStorage.ticketTitle#SESSION.userID#);
                $("##tracker-header-timing").text(sVal1);
                $('.realTime').text(sVal);
            }else{
                $('##tracker-header').text('');
                $('##tracker-header-timing').text('');
            }

          }
        }else{
          if(typeof(localStorage.tracker#SESSION.userID#) !== 'undefined'){
            if(localStorage.tracker#SESSION.userID# === '' ){
              callAjaxTracker();
            }
          }else{
            callAjaxTracker();
          }
        }
      }
      <cfif SESSION.userType eq 2 OR SESSION.userType eq 4>
        updateTrackerTime();
        var upTime = setInterval(function () {updateTrackerTime()}, 300000);
      </cfif>
      
      function updateTrackerTime(){
        var aload = true;
        if(typeof(localStorage.tracker#SESSION.userID#) !== 'undefined'){
          if(localStorage.tracker#SESSION.userID# === '' ){
            aload = false;
          }
        }
        if(aload){
          callAjaxTracker();
        }
      }
      function callAjaxTracker(){
        var ut = new Date();
          $.ajax({
            type: 'GET',
            url: '/index.cfm/main/updateTracker',
            dataType : 'json',
            success: function(data){
              if(data.success){
                if(data.trackID !== ''){
                  localStorage.tracker#SESSION.userID# = data.trackID ;
                  localStorage.ticketTitle#SESSION.userID# = data.ticket.title;
                  localStorage.ticketCode#SESSION.userID# = data.ticket.code;
                  localStorage.h#SESSION.userID# = data.h;
                  localStorage.n#SESSION.userID# = data.n;
                  localStorage.isPause#SESSION.userID# = data.isPause;
                  localStorage.s#SESSION.userID# = typeof(localStorage.s#SESSION.userID#) === 'undefined' ? 0 : localStorage.s#SESSION.userID#;
                }else{
                  localStorage.tracker#SESSION.userID# = '' ;
                }
                nMess = data.notification;
                // if(data.notification != '' && notification == null){
                  // notifyMe();
                // }
              }else{
                localStorage.tracker#SESSION.userID# = '' ;
              }
              localStorage.updateTime#SESSION.userID# = ut;
            }
          });

      }
    </script>
  </cfif>
</cfoutput>
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace.onpage-help.css" />
    <link rel="stylesheet" href="/ACEAdmin/docs/assets/js/themes/sunburst.css" />

    <script type="text/javascript"> ace.vars['base'] = '..'; </script>
    <script src="/ACEAdmin/assets/js/ace/ace.onpage-help.js"></script>
    <script src="/ACEAdmin/docs/assets/js/rainbow.js"></script>
    <script src="/ACEAdmin/docs/assets/js/language/generic.js"></script>
    <script src="/ACEAdmin/docs/assets/js/language/html.js"></script>
    <script src="/ACEAdmin/docs/assets/js/language/css.js"></script>
    <script src="/ACEAdmin/docs/assets/js/language/javascript.js"></script>
    <script src="/ACEAdmin/assets/js/bootstrap-tag.min.js"></script>



