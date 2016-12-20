<cfscript>
  function arrayOfStructsSort(aOfS,key){
          //by default we'll use an ascending sort
          var sortOrder = "ASC";
          //by default, we'll use a textnocase sort
          var sortType = "textnocase";
          //by default, use ascii character 30 as the delim
          var delim = ".";
          //make an array to hold the sort stuff
          var sortArray = arraynew(1);
          //make an array to return
          var returnArray = arraynew(1);
          //grab the number of elements in the array (used in the loops)
          var count = arrayLen(aOfS);
          //make a variable to use in the loop
          var ii = 1;
          //if there is a 3rd argument, set the sortOrder
          if(arraylen(arguments) GT 2)
              sortOrder = arguments[3];
          //if there is a 4th argument, set the sortType
          if(arraylen(arguments) GT 3)
              sortType = arguments[4];
          //if there is a 5th argument, set the delim
          if(arraylen(arguments) GT 4)
              delim = arguments[5];
          //loop over the array of structs, building the sortArray
          for(ii = 1; ii lte count; ii = ii + 1){
            var sortKey = aOfS[ii][key] ;
              sortArray[ii] = sortKey & delim & ii;
          }
          //now sort the array
          arraySort(sortArray,sortType,sortOrder);
          //now build the return array
          for(ii = 1; ii lte count; ii = ii + 1)
              returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
          //return the array
          return returnArray;
  }
</cfscript>
<cfset request.layout = false>
<cfsetting enableCFoutputOnly = "Yes">
<cfcontent type="application/msexcel; charset=windows-1252">
<cfheader name="Content-Disposition" value="filename=AnnaulLeaveReport#rc.exportYear#.xls">
<cfoutput>
  <style type="text/css">
    table {
      border-collapse: collapse;
    }
    tr.odd{
      background-color: ##999;
    }
    td.header{
      border:1px solid black;
      background-color: ##ddd;
    }
    td{
      border-left: 1px solid black;
      border-right: 1px solid black;
      padding-left: 5px;
      padding-right: 5px;
    }
  </style>
  <h1 style="width:100px;text-align:center;">AnnualLeaveReport#rc.exportYear#</h1>
  <table class="" cell-spacing="3">
    <thead>
      <tr>
        <td class="header">No</td>
        <td class="header">Name</td>
        <td class="header">Date</td>
        <td class="header">Type</td>
        <td class="header">AL</td>
        <td class="header">SL</td>
        <td class="header">OT</td>
        <td class="header" width="500">Reason</td>
      </tr>
    </thead>
    <tbody>
      <cfset no = 0 >
      <cfloop collection=#rc.oData# index="key">
        <cfset no++ >
        <cfset rowLen = arrayLen(rc.oData[key].data)>
        <cfset tal = 0>
        <cfset tsl = 0>
        <cfset tot = 0>
        <cfif rowLen eq 0>
          <tr>
            <td align="center" style="text-align: center; vertical-align: middle;">#no#</td>
            <td align="center" style="text-align: center; vertical-align: middle;">#rc.oData[key].name#</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
        <cfelse>
          <cfset isFirst = true>
          <cfset rowsData = arrayOfStructsSort(rc.oData[key].data,"idate")>
          <cfloop array=#rowsData# index="rowData">
            <cfset tal += rowData.al>
            <cfset tsl += rowData.sl>
            <cfset tot += rowData.ot>
            <tr>
              <cfif isFirst>
                <cfset isFirst = false>
                <td rowspan="#rowLen#" align="center" style="text-align: center; vertical-align: middle;">#no#</td>
                <td rowspan="#rowLen#" align="center" style="text-align: center; vertical-align: middle;">#rc.oData[key].name#</td>
              </cfif>
              <td align="center" style="text-align: center;">#rowData.date#</td>
              <td align="center" style="text-align: center;">#rowData.type#</td>
              <td align="center" style="text-align: center;"><cfif rowData.al gt 0>#rowData.al#</cfif></td>
              <td align="center" style="text-align: center;"><cfif rowData.sl gt 0>#rowData.sl#</cfif></td>
              <td align="center" style="text-align: center;"><cfif rowData.ot gt 0>#rowData.ot#</cfif></td>
              <td align="center" style="text-align: left;white-space: nowrap;">#rowData.reason#</td>
            </tr>
          </cfloop>
        </cfif>
          <tr class="odd">
            <td></td>
            <td></td>
            <td></td>
            <td align="right" style="text-align: right;">Total</td>
            <td align="center" style="text-align: center;">#tal#</td>
            <td align="center" style="text-align: center;">#tsl#</td>
            <td align="center" style="text-align: center;">#tot#</td>
            <td></td>
          </tr>
          <tr class="odd">
            <td></td>
            <td></td>
            <td align="center" style="text-align: center;"></td>
            <td align="right" style="text-align: right;">Rest of days off</td>
            <td align="center" style="text-align: center;">#rc.oData[key].remain.al#</td>
            <td align="center" style="text-align: center;">#rc.oData[key].remain.sl#</td>
            <td align="center" style="text-align: center;">#rc.oData[key].remain.ot#</td>
            <td>Last updated at #rc.oData[key].remain.date#</td>
          </tr>
      </cfloop>
    </tbody>
  </table>
</cfoutput>