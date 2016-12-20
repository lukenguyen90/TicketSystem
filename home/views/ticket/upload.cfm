<link rel="stylesheet" href="/css/jquery.fileupload-ui.css">

<script src="/js/jquery.ui.widget.js"></script>
<script src="/js/jquery.iframe-transport.js"></script>
<script src="/js/jquery.fileupload.js"></script>
<script src="/js/jquery.fileupload-fp.js"></script>
<script src="/js/jquery.fileupload-ui.js"></script>
<script src="/js/locale.js"></script>

<!-- Button trigger modal -->

<!-- Modal -->


<script type="text/javascript">
$(function () {
    'use strict';


    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload();

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        {redirect:window.location.href.replace(/\/[^\/]*$/,'/cors/result.html?%s'),
        	singleFileUploads: true,
        	limitConcurrentUploads: 3,
        	maxNumberOfFiles:10,
        	maxFileSize:20000000,
        	// resizeSourceFileTypes: /^image\/(gif|jpeg|png|jpg)$/,
      		resizeSourceMaxFileSize: 20000000, // 20MB
          uploadTemplate: function (o) {
            var rows = $();
            $.each(o.files, function (index, file) {
            	// file.error=false;
                var row = $('<tr class="template-upload fade">' +
                    '<td><div class="row name"></div>'+
                    (file.error ?  '<div class="row"><div class="error col-md-10"></div><div class="col-md-2></div></div></td>' :'<div class="row"><div class="progress progress-success  active col-md-8"><div class="bar" style="width:0%;"></div></div><span class="size col-md-4" ></span></div></td><td class="start"><button class="btn btn-sm btn-success"><i class="ace-icon fa fa-upload"></i></button></td>' )+
                     '<td class="cancel"><button class="btn btn-sm btn-warning">' +
                      '<i class="ace-icon fa fa-close"></i>' +
                  '</button></td></tr>');
                row.find('.name').text(file.name);
                row.find('.size').text(o.formatFileSize(file.size));
                if (file.error) {
                    row.find('.error').text(
                        locale.fileupload.errors[file.error] || file.error
                    );
                }
                rows = rows.add(row);
            });
            $('button.start').prop('disabled',false);
            return rows;
          },
        downloadTemplate: function (o) {
            $('button.start').prop('disabled',true);
            $('button.cancel').prop('disabled',false);
          var rows = $();
          $.each(o.files, function (index, file) {
          	// file.error=false;
              var row = $('<tr class="template-download fade">' +
                  (file.error ? '<td></td><td class="name"></td>' +
                      '<td class="size"></td><td class="error" colspan="2"></td>' :
                          '<td class="preview"></td>' +
                              '<td class="name"><a></a></td>' +
                              '<td class="size"></td><td colspan="2"></td>'
                  ) + '<td class="delete"><button class="btn btn-danger" onClick=\'del("'+file.url+'")\'><i class="icon-trash icon-white"></i><span >Delete</span></button>' +
                      ' </td></tr>');
              row.find('.size').text(o.formatFileSize(file.size));
              if (file.error) {
                  row.find('.name').text(file.name);
                  row.find('.error').text(
                      locale.fileupload.errors[file.error] || file.error
                  );
              } else {
                  row.find('.name a').text(file.name);
                  $("#ListFileUpload").val($("#ListFileUpload").val()+","+file.url);
                  //set name after upload success
                  if (file.thumbnail_url) {
                
                      row.find('.preview').append('<a><img></a>')
                          .find('img').prop('src', file.thumbnail_url);
                      row.find('a').prop('rel', 'gallery');
                  }
                  row.find('a').prop('href', file.url);

              }
              rows = rows.add(row);
          });
            $('button.cancel').prop('disabled',true);
          return rows;
      },

      submit: function (e, data) {


      	var vWidth,vHeight;

				vWidth=1024;
				vHeight=768;

      	var resizeSettings = [
                {resizeMaxWidth: vWidth,resizeMaxHeight: vHeight}
            ],
            $this = $(this),
            originalFile = data.files[0],
            filestoSubmit = [],
            deferred = $.Deferred(),
            promise = deferred.promise();
        $.each(resizeSettings, function (index, settings) {
            promise = promise.pipe(function () {
                filestoSubmit.push(data.files[0]);
                data.files = [originalFile];
                $.extend(data, settings);
                return $this.fileupload('resize', data);
            });
        });
        deferred.resolve();
        promise.done(function () {
            filestoSubmit.push(data.files[0]);
            data.files = filestoSubmit;
            $this.fileupload('send', data);
        });
        return false;



      }

     }
   );

});

	function del(string){
		$("#ListFileUpload").val($("#ListFileUpload").val().replace(","+string,""));
	}


</script>