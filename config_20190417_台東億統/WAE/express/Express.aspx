<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Express.aspx.cs" Inherits="AutoDiscoverWeb.Express" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="headExpress" runat="server">
    <meta content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <title>WebAccess Express</title>
    <link type="text/css" rel="stylesheet" href="css/custom-theme/jquery-ui-1.10.3.custom.css" />
    <link type="text/css" rel="stylesheet" href="css/ui.jqgrid.css" />
    <link type="text/css" rel="stylesheet" href="css/AutoDiscoverStyle.css" />
	<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="js/i18n/grid.locale-en.js"></script>
    <script type="text/javascript" src="js/jquery.jqGrid.min.js"></script>
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>
    <!--[if lt IE 8]><script type="text/javascript" src="js/json2.js"></script><![endif]-->
	<script type="text/javascript">
	    $(function () {
	        $("#tabs").tabs({

	        });
	    });
    </script>
</head>
<body bgcolor="#8D8C8F">
    <form id="formDevList" name="formDevList" runat="server" action="Express.aspx">
        <div class="title">
            <table width="100%">
                <tr>
                    <td width="95%" align="center">WebAccess Express</td>
                    <td width="5%" align="right">
                        <a href="/broadWeb/bwproj.asp"><font class="e4" color="blue"><%= AspVCObjMsg_Home %></font></a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="contents">
            <table class="wbTable" width="100%" cellspacing="0" cellpadding="5" border="0">
                <tr>
                    <td width="50%" align="right">
                        <asp:Literal ID="projNameLiteral" runat="server"></asp:Literal>
                    </td>
                    <td width="50%" align="left">
                        <asp:TextBox ID="projNameTextBox" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="right">
                        <asp:Literal ID="nodeNameLiteral" runat="server"></asp:Literal>
                    </td>
                    <td width="50%" align="left">
                        <asp:TextBox ID="nodeNameTextBox" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="right">
                        <asp:Literal ID="totalPointsLiteral" runat="server"></asp:Literal>
                    </td>
                    <td width="50%" align="left">
                        <font id="totalPointsValue"></font>
                    </td>
                </tr>
            </table>
        </div>
        <div id="tabs" style="margin-top:25px">
    	    <ul style="margin-bottom:5px">
		        <li><a href="#tabs1"><%= AspVCObjMsg_DeviceList %></a></li>
		        <li><a href="#tabs2"><%= AspVCObjMsg_Setting %></a></li>
	        </ul>
	        <div id="tabs1" align="center">
                <table id="devListTable"></table>
                <%--<div id="devListGridPager"></div>--%>
	        </div>
	        <div id="tabs2">
                <%--<table id="miscellaneousTable"></table>--%>
                <div id="comPortDiv">
                    <table id="comPortTable"></table>
                </div>
                <div id="snmpDiv">
                    <table id="snmpTable"></table>
                </div>
	        </div>
            <div align="center">
                <table width="20%">
                    <tr>
                        <td width="10%" align="center">
                            <input type="button" value="<%= AspVCObjMsg_Discover %>" onclick="goDiscover()" />
                        </td>
                        <td width="10%" align="center">
                            <input type="button" value="<%= AspVCObjMsg_Submit %>" onclick="goApply()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <input type="hidden" id="selectedDevListData" name="selectedDevListData" />
        <input type="hidden" id="selectedComListData" name="selectedComListData" />
        <input type="hidden" id="selectedSnmpListData" name="selectedSnmpListData" />
        <input type="hidden" id="Discover" name="Discover" value="0" />
        <input type="hidden" id="Apply" name="Apply" value="0" />
    </form>
</body>
<script type="text/javascript">
    var limitTotalPoints = <%= WebAccessPointsLimit %>;
    var currentTotalPoints;

    $("#devListTable").jqGrid({
        datatype: 'local',
        height: 'auto',
        colNames: ['<%= AspVCObjMsg_DeviceType %>', '<%= AspVCObjMsg_DeviceName %>', '<%= AspVCObjMsg_UnitNumber %>', '<%= AspVCObjMsg_Address %>', '<%= AspVCObjMsg_TagCount %>'],
        colModel: [
            { name: 'devType', index: 'devType', sorttype: "text", align: 'center' },
            { name: 'devName', index: 'devName', sorttype: "text", align: 'center' },
            { name: 'unitNum', index: 'unitNum', sorttype: "int", align: 'center' },
            { name: 'addr', index: 'addr', sorttype: "text", align: 'center' },
            { name: 'tagCount', index: 'tagCount', sorttype: "int", align: 'center' }
   	    ],
        multiselect: true,
        caption: '<%= AspVCObjMsg_DeviceList %>',
        rowNum: 20,
        rowList: [20, 50, 100],
        //pager: '#devListGridPager',
        sortname: 'devType',
        cmTemplate: {sortable:false},
        viewrecords: true,
        onSelectRow: function(rowid, status, e)
        {
            var tagCount = $("#devListTable").jqGrid('getCell',rowid,'tagCount');

            if(status)
            {
                if(limitTotalPoints == 0 || parseInt(tagCount,10) + currentTotalPoints <= limitTotalPoints)
                    currentTotalPoints += parseInt(tagCount,10);
                else
                    $("#devListTable").jqGrid('setSelection', rowid, false);
            }
            else
                currentTotalPoints -= parseInt(tagCount,10);

            if(limitTotalPoints == 0)
                $("#totalPointsValue").text(currentTotalPoints + " / <%= AspVCObjMsg_Unlimited %>");
            else
                $("#totalPointsValue").text(currentTotalPoints + " / " + limitTotalPoints);
        },
        onSelectAll: function(aRowids,status)
        {
            var ids = $("#devListTable").getDataIDs();
            currentTotalPoints = 0;
            if(status)
            {
                for(var i=0; i<ids.length; i++)
                {
                    var tagCount = $("#devListTable").jqGrid('getCell',ids[i],'tagCount');
                    if(limitTotalPoints == 0 || parseInt(tagCount,10) + currentTotalPoints <= limitTotalPoints)
                        currentTotalPoints += parseInt(tagCount,10);
                    else
                        $("#devListTable").jqGrid('setSelection', ids[i], false);
                }
                $("#cb_devListTable").prop("checked", true);
            }

            if(limitTotalPoints == 0)
                $("#totalPointsValue").text(currentTotalPoints + " / <%= AspVCObjMsg_Unlimited %>");
            else
                $("#totalPointsValue").text(currentTotalPoints + " / " + limitTotalPoints);
        },
        loadComplete: function()
        {
            var devListGridData = <%= DevListGridString %>;
            for (var i = 0; i <= devListGridData.length; i++)
                $("#devListTable").jqGrid('addRowData', i + 1, devListGridData[i]);
            var ids = $("#devListTable").getDataIDs();
            currentTotalPoints = 0;
            $("#devListTable").jqGrid('resetSelection');
            for(var i=0; i<ids.length; i++)
            {
                var tagCount = $("#devListTable").jqGrid('getCell',ids[i],'tagCount');
                if(limitTotalPoints == 0 || parseInt(tagCount,10) + currentTotalPoints <= limitTotalPoints)
                {
                    $("#devListTable").jqGrid('setSelection', ids[i], false);
                    currentTotalPoints += parseInt(tagCount,10);
                }
            }
            $("#cb_devListTable").prop("checked", true);

            if(limitTotalPoints == 0)
                $("#totalPointsValue").text(currentTotalPoints + " / <%= AspVCObjMsg_Unlimited %>");
            else
                $("#totalPointsValue").text(currentTotalPoints + " / " + limitTotalPoints);
            $("#devListTable").jqGrid('setGridWidth',$("#tabs").width()-5,true);
        }
    });
    //$("#devListTable").jqGrid('navGrid', '#devListGridPager', { edit: false, add: false, del: false });
    //$("#devListTable").trigger("reloadGrid");

    $("#comPortTable").jqGrid({
        datatype: 'local',
        height: 'auto',
        colNames: ['<%= AspVCObjMsg_COMportNumber %>', '<%= AspVCObjMsg_State %>'],
        colModel: [
            { name: 'comPort', index: 'comPort', sorttype: "text", align: 'center' },
            { name: 'state', index: 'state', sorttype: "text", align: 'center' }
   	    ],
        multiselect: true,
        caption: '<%= AspVCObjMsg_COMsetting %>',
        rowNum: 10,
        rowList: [10, 20, 50],
        //pager: '#comListGridPager',
        sortname: 'comPort',
        cmTemplate: {sortable:false},
        viewrecords: true,
        onSelectRow: function(rowid, status)
        {
            if(status)
            {
                if($("#jqg_comPortTable_"+rowid).attr("disabled"))
                    $("#comPortTable").jqGrid('setSelection', rowid, false);
            }
        },
        onSelectAll: function(aRowids,status)
        {
            if(status)
            {
                var ids =$("#comPortTable").jqGrid('getDataIDs');
                for(var i=0; i<ids.length; i++)
                {
                    if($("#jqg_comPortTable_"+ids[i]).attr("disabled"))
                        $("#comPortTable").jqGrid('setSelection', ids[i], false);
                }
                $("#cb_comPortTable").prop("checked", true);
            }
        },
        loadComplete: function()
        {
            var comListGridData = <%= ComListGridString %>;
            for (var i = 0; i <= comListGridData.length; i++)
                $("#comPortTable").jqGrid('addRowData', i + 1, comListGridData[i]);

            var ids =$("#comPortTable").jqGrid('getDataIDs');
            for(var i=0; i<ids.length; i++)
            {
                if($("#comPortTable").jqGrid('getCell',ids[i],"state") == "<%= AspVCObjMsg_Occupied %>" || 
                    $("#comPortTable").jqGrid('getCell',ids[i],"state") == "<%= AspVCObjMsg_Conflict %>")
                    $("#jqg_comPortTable_"+ids[i]).attr("disabled", "disabled");
                else
                    $("#comPortTable").jqGrid('setSelection', ids[i], false);
            }
            $("#cb_comPortTable").prop("checked", true);
            $("#comPortTable").jqGrid('setGridWidth',$("#tabs").width(),true);
            if(comListGridData.length == 0)
                $("#comPortDiv").hide();
        }
    });

    $("#snmpTable").jqGrid({
        datatype: 'local',
        height: 'auto',
        colNames: ['<%= AspVCObjMsg_StartIP %>', '<%= AspVCObjMsg_EndIP %>', '<%= AspVCObjMsg_Port %>'],
        colModel: [
            { name: 'startIP', index: 'startIP', sorttype: "text", align: 'center' },
            { name: 'endIP', index: 'endIP', sorttype: "text", align: 'center' },
            { name: 'portNum', index: 'portNum', sorttype: "text", align: 'center' }
   	    ],
        multiselect: true,
        caption: '<%= AspVCObjMsg_SNMPsetting %>',
        rowNum: 10,
        rowList: [10, 20, 50],
        //pager: '#snmpGridPager',
        sortname: 'id',
        cmTemplate: {sortable:false},
        viewrecords: true,
        loadComplete: function()
        {
            var snmpListGridData = <%= SnmpListGridString %>;
            for (var i = 0; i <= snmpListGridData.length; i++)
                $("#snmpTable").jqGrid('addRowData', i + 1, snmpListGridData[i]);

            var ids =$("#comPortTable").jqGrid('getDataIDs');
            for(var i=0; i<ids.length; i++)
                $("#snmpTable").jqGrid('setSelection', ids[i], false);
            $("#cb_snmpTable").prop("checked", true);
            $("#snmpTable").jqGrid('setGridWidth',$("#tabs").width(),true);
            if(snmpListGridData.length == 0)
                $("#snmpDiv").hide();
        }
    });

    function goDiscover()
    {
        var selComID, selSnmpID, comObj, snmpObj;
        var selComData = new Array();
        var selSnmpData = new Array();
        
        selComID = $("#comPortTable").jqGrid('getGridParam','selarrrow');
        for(var i=0; i<selComID.length; i++)
        {
            comObj = $("#comPortTable").jqGrid('getLocalRow', selComID[i]);
            if(!$("#jqg_comPortTable_"+selComID[i]).attr("disabled"))
                selComData.push(comObj);
        }
        document.getElementById("selectedComListData").value = JSON.stringify(selComData);

        selSnmpID = $("#snmpTable").jqGrid('getGridParam','selarrrow');
        for(var i=0; i<selSnmpID.length; i++)
        {
            snmpObj = $("#snmpTable").jqGrid('getLocalRow', selSnmpID[i]);
            if(!$("#jqg_snmpTable_"+selSnmpID[i]).attr("disabled"))
                selSnmpData.push(snmpObj);
        }
        document.getElementById("selectedSnmpListData").value =  JSON.stringify(selSnmpData);
        document.getElementById("Discover").value = "1";
        
        $("#formDevList").block({ message: '<img src="/broadweb/express/images/loading.gif" style="vertical-align:middle" /> <%= AspVCObjMsg_Discovering %>...',
                                  css: { background: '#fbfbfb',
                                         width: '180px',
                                         height: '35px',
                                         padding: '5px',
                                         color: '#222',
                                         border: '2px solid #6593cf',
                                         font: 'normal 22px tahoma, arial, helvetica, sans-serif'
                                   }
                                });
        $("#formDevList").submit();
    }

    function goApply()
    {
	    var applyObj;
        var selData = new Array();

        var ids = $("#devListTable").jqGrid('getDataIDs');
        for(var i=0; i<ids.length; i++)
        {
            if($("#jqg_devListTable_"+ids[i]+":checked").length > 0)
            {
                applyObj = $("#devListTable").jqGrid('getLocalRow', ids[i]);
                selData.push(applyObj);
            }
        }

        if(selData.length == 0)
            return;
        document.getElementById("selectedDevListData").value = JSON.stringify(selData);
        document.getElementById("Apply").value = "1";

        $("#formDevList").block({ message: '<img src="/broadweb/express/images/loading.gif" style="vertical-align:middle" /> <%= AspVCObjMsg_Applying %>...',
                                  css: { background: '#fbfbfb',
                                         width: '180px',
                                         height: '35px',
                                         padding: '5px',
                                         color: '#222',
                                         border: '2px solid #6593cf',
                                         font: 'normal 22px tahoma, arial, helvetica, sans-serif'
                                   }
                                });

        $("#formDevList").submit();
    }

    $(window).resize(function() {
        $("#devListTable").jqGrid('setGridWidth',$("#tabs").width(),true);
        $("#comPortTable").jqGrid('setGridWidth',$("#tabs").width(),true);
        $("#snmpTable").jqGrid('setGridWidth',$("#tabs").width(),true);
    })
</script>
</html>

