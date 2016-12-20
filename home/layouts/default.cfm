<cfoutput>
<!DOCTYPE html>
<!-- saved from url=(0056)http://responsiweb.com/themes/preview/ace/1.3/index.html -->
<html lang="en">

    <head>
        <link rel="apple-touch-icon" sizes="57x57" href="/apple-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="/apple-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="/apple-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="/apple-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="/apple-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="/apple-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="/apple-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="/apple-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-icon-180x180.png">
        <link rel="icon" type="image/png" sizes="192x192"  href="/android-icon-192x192.png">
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="96x96" href="/favicon-96x96.png">
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
        <link rel="manifest" href="/manifest.json">
        <meta name="msapplication-TileColor" content="##ffffff">
        <meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
        <meta name="theme-color" content="##ffffff">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="utf-8">
    <cfif structKeyExists(rc,"useNotTicketCss")>
        
        <title>Rasia Tickets System | Ticket Not Found</title>
        <style type="text/css">
            .nTicket{
                background: rgba(221,221,221,1) no-repeat;
            }
            .nTicket .content-container{
                z-index: 1;
            }
            .nTicket h1{
                /* Using the custom font we've included in the HTML tab: */
                font-family: Satisfy, cursive;
                font-weight:normal;
                font-size:80px;
                padding-top: 60px;
            }

            .nTicket h2.small-quote{
                /* Using the custom font we've included in the HTML tab: */
                font-family: Satisfy, cursive;
                font-weight:normal;
                font-size:32px;
            }

            .nTicket h3{
                /* Using the custom font we've included in the HTML tab: */
                font-family: Satisfy, cursive;
                font-weight:normal;
                font-size:32px;
            }

            .nTicket .text-align-center{
                text-align: center;
            }

            .nTicket .content-container{
                position: relative;
                width: 100%;
            }

            .nTicket .e-logo{
                position: absolute;
                top: 0;
                right: 56%;
                z-index: -1;
                transform: translateX(-50%);    
            }
            .nTicket .logo{
                position: absolute;
                top: 0;
                right: 50%;
                z-index: -1;
                transform: translateX(-50%);    
            }

            @media (max-width: 1024px){
                .nTicket h1{
                    font-size: 65px;
                }

                .nTicket h2.small-quote{
                    font-size: 26px;
                }

                .nTicket h3{
                    font-size: 24px;
                }

            }

            @media (max-width: 768px){
                .nTicket h1{
                    font-size: 48px;
                }

                .nTicket h2.small-quote{
                    font-size: 20px;
                }

                .nTicket h3{
                    font-size: 20px;
                }

                .nTicket .e-logo{
                    top:5%;
                    width: 72px;
                }
            }
        </style>

        <link href="http://fonts.googleapis.com/css?family=Satisfy" rel="stylesheet" />
    <cfelse>
        <title>Rasia Tickets System</title>
    </cfif>
    <meta name="description" content="overview &amp; stats">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
 
    <link rel="stylesheet" href="/ACEAdmin/assets/css/jquery-ui.custom.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/css/Font-Awesome-master/css/font-awesome.min.css" />
    <!--- <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"> --->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/jquery-ui.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/chosen.css">
    <link rel="stylesheet" href="/ACEAdmin/assets/css/datepicker.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ui.jqgrid.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-fonts.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace.min.css" />
    <link rel="stylesheet" href="/css/jquery.fileupload-ui.css">
    <link rel="stylesheet" href="/css/tooltipster.css">
    <link rel="stylesheet" href="/ACEAdmin/assets/css/bootstrap-timepicker.css" />
    <link rel="stylesheet" href="/css/themes/tooltipster-shadow.css">
    <link rel="stylesheet" href="/css/multiple-select.css" />
    <link rel="stylesheet" href="/css/ace.css" />
    <!--- <link rel="stylesheet" href="/css/style.css" /> --->
    <link rel="stylesheet" href="/css/loadingbar.css" />
    <link rel="stylesheet" href="/css/loadingBarInPage.css" />
    <!--- <link rel="stylesheet" href="/css/global.css"> --->
    <link rel="stylesheet" href="/css/time_use_report.css">
    <link rel="stylesheet" href="/css/timebars.css">
    <link rel="stylesheet" href="/css/bootstrap-select2.css">

    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-skins.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-rtl.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-rtl.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/colorpicker.css" />
    <link rel="stylesheet" href="/css/daterangepicker.css">
    <!-- CSS Calendar -->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/fullcalendar.css" />

    <!-- ace settings handler -->
    <script src="/ACEAdmin/assets/js/jquery.min.js"></script>
    <script src="/js/jquery.ui.widget.js"></script>
    <script src="/js/jquery.iframe-transport.js"></script>
    <script src="/js/jquery.fileupload.js"></script>
    <script src="/js/jquery.fileupload-fp.js"></script>
    <script src="/js/jquery.fileupload-ui.js"></script>
    <script src="/js/locale.js"></script>
    <script src="/js/main.js"></script>
    <script src="/js/moment.min.js"></script>
    <script src="/js/bootstrap-datepicker.js"></script>
    <script src="/js/daterangepicker.js"></script>

    <script src="/js/jquery.tooltipster.js"></script>
    <script src="/js/jquery.multiple.select.js"></script>
    <script src="/ACEAdmin/assets/js/ace-extra.min.js"></script>
    <script src="/js/md5.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.dataTables.min.js"></script>
    <script src="/ACEAdmin/assets/js/jquery.dataTables.bootstrap.js"></script>
    <script src="/ACEAdmin/assets/js/chosen.jquery.min.js"></script>  
    <script src="/ACEAdmin/assets/js/date-time/bootstrap-datepicker.min.js"></script>
    <script src="/js/typeahead.js"></script>
    <!-- <script src="/js/td-global.js"></script>
    <script src="/js/time_use_report.js"></script>
     -->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <script type="text/javascript">
        function loadResources()
        {
            $.ajax({
                      type: "post",
                      url: "#getContextRoot()#/index.cfm/home:helper/loadResources",
                      data:{},
                      dataType: "json",
                      success: function(){
                            alert('Your resources have been reloaded !');      
                            location.reload(); 
                        }
                  });
        }
    </script>


  <body class="no-skin">
    <div id="waiting" class="col-md-12 modal-loading flash hide">
      <div class="alert alert-info">
        <strong><i class="ace-icon fa fa-spinner fa-spin blue bigger-250"></i>  #getLabel("Loading", #SESSION.languageId#)#..</strong>

        #getLabel("Please wait for a few seconds.", #SESSION.languageId#)#
        <br>
      </div>
    </div>
    
    #view("common/header")#
    <div class="main-container" id="main-container">
      
      #view("common/menu")#

      <div class="main-content">
        <div class="page-content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- PAGE CONTENT BEGINS -->
                    #body#
                    <!-- PAGE CONTENT ENDS -->
                </div><!-- /.col -->
            </div><!-- /.row -->
        </div>

      </div>

      #view( "common/footer" )#
      
    </div>
    <script type="text/javascript">
    $(document).ready(function(){
        $("##waiting").addClass('hide');
    });
   </script>
   </body>
</html>
</cfoutput>
