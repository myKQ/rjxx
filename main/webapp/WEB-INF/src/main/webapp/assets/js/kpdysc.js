/**
 * Created by lenovo on 2017/02/11.
 */
(function ($) {
    'use strict';
    $(function () {
      /*  $.ajax({
            url: "lrkpd/getXfxx", context: null, success: function (data) {
                $("#qymc").val(data.xfmc);
                $("#nsrsbh").val(data.xfsh);
            }
        });*/
             

        var jyls_table2 = $('#jyls_table2').DataTable({
            "searching": false,
            "serverSide": true,
            "sServerMethod": "POST",
            "processing": true,
            "scrollX": true,
            ordering: false,
            ajax: {
                "url": "lrkpd/getyscjyxxsqlist?clztdm=00",
                type: 'post',
                data: function (d) {
                    d.xfsh = $('#xfsh2').val();   // search 销方
                    d.gfmc = $('#gfmc2').val();	// search 购方名称
                    d.ddh = $('#ddh2').val();   // search 订单号
                   // d.fpzldm = $('#fpzldm').val();   // search 发票号码
                    d.rqq = $('#kssj2').val(); // search 开票日期
                    d.rqz = $('#jssj2').val(); // search 开票日期
                    d.fpzldm = $('#fplxdm2').val(); // search发票种类
                    var csm =  $('#dxcsm2').val()
	                if("gfmc2"==csm&&(d.gfmc==null||d.gfmc=="")){
	                    d.gfmc = $('#dxcsz2').val()
	                 }else if("ddh2"==csm&&(d.ddh==null||d.ddh=="")){
	                    d.ddh = $('#dxcsz2').val()
	                  }
                }
            },
            "columns": [
                {"data": "sqlsh"},
                // {"data": "clztdm"},
                {"data": "jylsh"},
                {"data": "ddh"},
                {"data": "ddrq"},
                {"data": function(data){
                	if("01"==data.fpzldm){
                	 	return "专用发票";
                	}else if("02"==data.fpzldm){
                	 	return "普通发票";
                	}
                	else if("12"==data.fpzldm){
                	 	return "电子发票";
                	}else{
                		return "";
                	}
               
                }},
                {"data": "gfmc"},
                {"data": "gfsh"},
                {"data": "gfdz"},
                {"data": "gfdh"},
                {"data": "gfyh"},
                {"data": "gfyhzh"},
                {"data": function (data) {
                    if (data.jshj) {
                        return FormatFloat(data.jshj, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
               // {"data": "lrry"},
               
            ],
            // "columnDefs": [
            //     {
            //         "bVisible": false, "aTargets": [0]
            //     }],
            "createdRow": function (row, data, index) {
                $('td', row).eq(0).html('<input type="checkbox" data="' + data.sqlsh + '" name="chk"/>');
            }
        });
        
        jyls_table2.on('click', 'tr', function () {
              $(this).css("background-color", "#B0E0E6").siblings().css("background-color", "#FFFFFF");
        });

        var jyspmx_table2 = $('#jyspmx_table2').DataTable({
            "searching": false,
            "serverSide": true,
            "sServerMethod": "POST",
            "processing": true,
            ajax: {
                "url": "lrkpd/getjymxsqlist",
                data: function (d) {
                    d.sqlsh = $("#djh2").val();
                }
            },
            "columns": [
                {"data": "spmxxh"},
                {"data": "spmc"},
                {"data": "spggxh"},
                {"data": "spdw"},
                {"data": function (data) {
                    if (data.sps) {
                        return FormatFloat(data.sps, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                {"data": function (data) {
                    if (data.spdj) {
                        return FormatFloat(data.spdj, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                {"data": function (data) {
                    if (data.spje) {
                        return FormatFloat(data.spje, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                {"data": function (data) {
                    if (data.spsl) {
                        return FormatFloat(data.spsl, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                {"data": function (data) {
                    if (data.spse) {
                        return FormatFloat(data.spse, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                {"data": function (data) {
                    if (data.jshj) {
                        return FormatFloat(data.jshj, "###,###.00");
                    } else {
                        return null;
                    }
                }, 'sClass': 'right'},
                
            ]
        });

        $('#kp_search3').click(function () {
        	var dt1 = new Date($('#kssj2').val().replace(/-/g, "/"));
            var dt2 = new Date($('#jssj2').val().replace(/-/g, "/"));
            if (($('#kssj2').val() && $('#jssj2').val())) {// 都不为空
                if (dt1.getYear() == dt2.getYear()) {
                    if (dt1.getMonth() == dt2.getMonth()) {
                        if (dt1 - dt2 > 0) {
                            swal('开始日期大于结束日期!');
                            return false;
                        }
                    } 
                }
            }
            $("#dxcsz2").val("");
        	jyls_table2.ajax.reload();
        });
        
        $('#kp_search2').click(function () {
        	$("#ycform2").resetForm();
        	$('#kssj2').attr("selected","selected");
         	$('#jssj2').attr("selected","selected");
        	jyls_table2.ajax.reload();
        });
        
        $('#jyls_table2 tbody').on('click', 'tr', function () {
            if ($(this).hasClass('selected')) {
                $(this).removeClass('selected');
            } else {
                jyls_table2.$('tr.selected').removeClass('selected');
                $(this).addClass('selected');
            }
            var data = jyls_table2.row($(this)).data();
            $("#djh2").val(data.sqlsh);
            //alert(data.sqlsh);
            //$("#formid").val(data.djh);
            jyspmx_table2.ajax.reload();
        });
        var mxarr = [];
        var $modal = $("#my-alert-edit");
 
        $('#check_all2').change(function () {
        	if ($('#check_all2').prop('checked')) {
        		jyls_table2.column(0).nodes().each(function (cell, i) {
                    $(cell).find('input[type="checkbox"]').prop('checked', true);
                });
            } else {
            	jyls_table2.column(0).nodes().each(function (cell, i) {
                    $(cell).find('input[type="checkbox"]').prop('checked', false);
                });
            }
        });


  
        var index = 1;

        $('#my-alert-edit').on('open.modal.amui', function () {
//            $("#main_tab").tabs('open', 0);
        });
  
        $("#addRow").click(function () {
            var r = $("#mx_form").validator("isFormValid");
            if (r) {
                var spdm = $("#spdm_edit").val();
                var mc = $("#mc_edit").val();
                var ggxh = $("#ggxh_edit").val();
                var dw = $("#dw_edit").val();
                var sl = $("#sl_edit").val();

                var dj = $("#dj_edit").val();
                var je = $("#je_edit").val();
                var sltaxrate = $("#sltaxrate_edit").val();
                var se = $("#se_edit").val();
                var jshj = $("#jshj_edit").val();
                index = mxarr.length + 1;
     
                mxarr.push(index);
            }
        });





        $("#close").click(function () {
            $modal.modal("close");
        });
        //批量导入
        var $importModal = $("#bulk-import-div");
      
        $("#close1").click(function () {
            $importModal.modal("close");
        });
        $("#mxclose").on('click', function() {
			$('#my-alert-edit1').modal('close');
		});
        $("#close2").click(function () {
            $importConfigModal.modal("close");
//        	$importConfigModal.modal({"width": 600, "height": 480});
        });
        $("#close3").click(function () {
        	$('#my-alert-modify').modal('close');
        }); 
        //导入配置
        var $importConfigModal = $("#import_config_div");
        $("#btnImportConfig").click(function () {
//            $importModal.modal("close");
            $('#importConfigForm').resetForm();
            $importConfigModal.modal({"width": 600, "height": 480});
        });
    });
})(jQuery);

	
	$("a").on('click',function() {
		var date =  $(this).attr("id")
		//alert( $(this).attr("id"));
		if(date=='day3'){
			var k =getToday();
			var j = getThreeday(2);
			$("#kssj").val(j);
			$("#jssj").val(k);
		}else if(date=='day7'){
			var k =getToday();
			var j = getThreeday(6);
			$("#kssj").val(j);
			$("#jssj").val(k);
		}else if(date=='day30'){
			var k =getToday();
			var j = getThreeday(29);
			$("#kssj").val(j);
			$("#jssj").val(k);
		}
	});

	
	//当前日期
	function getToday() {
		var date = new Date();
		var strYear = date.getFullYear();
		var strDay = date.getDate();
		var strMonth = date.getMonth() + 1;
		if (strMonth < 10) {
			strMonth = "0" + strMonth;
		}
		datastr = strYear + "-" + strMonth + "-" + strDay;
		return datastr;
	}
	//获取最近n天
	function getThreeday(day) {
		var date = new Date();
		var threeday_milliseconds = date.getTime() - 1000 * 60 * 60 * 24 * day;
		var threeday = new Date();
		threeday.setTime(threeday_milliseconds);
		var strYear = threeday.getFullYear();
		var strDay = threeday.getDate();
		var strMonth = threeday.getMonth() + 1;
		if (strMonth < 10) {
			strMonth = "0" + strMonth;
		}
		datastr = strYear + "-" + strMonth + "-" + strDay;
		return datastr;
	}