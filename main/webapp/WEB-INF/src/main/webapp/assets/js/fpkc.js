/**
 * feel
 */
$(function () {
    "use strict";
    var ur ;
    var el = {
        $jsTable: $('.js-table'),//库存table
        $jsNewTable:$('#jsNewTable'),
        $modalHongchong: $('#hongchong'),//弹出div
        $jsClose: $('.js-close'),//取消按钮
        $jsForm: $('.js-form-kc'), //  form
        $s_fplx: $('#cfplx'), // search关键字
        $s_fpdm: $('#cfpdm'), // search关键字
        $jsSearch: $('#jsSearch'),//查询按钮
        $jsAdd: $('#jsAdd'),//新增按钮
        $xfsh: $('#xfsh'),//销方税号
        $kpddm: $('#kpddm'),//开票点代码
        $kpdmc: $('#kpdmc'),//开票点名称
        $fphms: $('#fphms'),//发票号码起
        $fphmz: $('#fphmz'),//发票号码止
        $fpdm: $('#fpdm'),//发票代码
        $fplx:$('#fplx')
    };
    
    var tb = el.$jsNewTable.DataTable({
        "processing": true,
        "serverSide": true,
        ordering: false,
        searching: false,
        "bPaginate":false,
        "bLengthChange":false,
        "bSort":false,
        "bInfo": false,
        "ajax": {
            url:'fpkc/getServerFpkc',
            type: 'POST',
            data: function (d) {                      
                d.skpid = $('#kpddm').val();
            }
        },
        "columns": [                        
            {"data": "xfmc"},
            {"data": "xfsh"},
            {"data": "kpdmc"},
            {"data":"fpzlmc"},
            {"data": "fpdm"},
            {"data": "fphms"},
            {"data": "fphmz"},
            {"data": "kyl"}
            ]
    });
    var loaddata = false;
    var action = {
        tableEx: null, // cache dataTable
        config: {
            getUrl: 'fpkc/getItems',
            xzUrl: 'fpkc/save',
            xgUrl: 'fpkc/update',
            xgcxUrl: 'fpkc/getXfmc',
            scUrl: 'fpkc/destory'
        },
        dataTable: function () {
            var _this = this;
            var t = el.$jsTable
                .DataTable({
                    "processing": true,
                    "serverSide": true,
                    ordering: false,
                    searching: false,
                    "scrollX": true,
                    "ajax": {
                        url: _this.config.getUrl,
                        type: 'POST',
                        data: function (d) {
                            var bz = $('#searchbz').val();
                            d.loaddata = loaddata;
                            if(bz=='1'){
                                d.xfids = $('#xfid').val();
                                d.skpids = $('#s_skpid').val();
                                d.fpdm= el.$s_fpdm.val(); // search 用户账号
                                d.fplx = el.$s_fplx.val();

                            }else{
                                var item = $('#s_mainkey').val();
                                if(item=='fpdm'){
                                    d.fpdm = $('#searchValue').val();
                                }
                            }
                            
                        }
                    },
                    "columns": [
                        {
                            "orderable": false,
                            "data": null,
                            "defaultContent": ""
                        },
                        {
                            "data": null,
                            "render": function (data) {
                                return '<a class="xiugai">修改</a> <a class="shanchu">删除</a> '
                            }
                        },
                        {"data": "xfmc"},
                        {"data": "xfsh"},
                        {"data": "kpdmc"},
                        {"data":"fpzlmc"},
                        {"data": "fpdm"},
                        {"data": "fphms"},
                        {"data": "fphmz"},
                        {"data": "fpkcl"},
                        {"data": "kyl"}
                        ]
                });
                   
            t.on('draw.dt', function (e, settings, json) {
                var x = t, page = x.page.info().start; // 设置第几页
                t.column(0).nodes().each(function (cell, i) {
                    cell.innerHTML = page + i + 1;
                });
            });

            
            // 修改
            t.on('click', 'a.xiugai', function () {
                var row = t.row($(this).parents('tr')).data();
                $('#tablediv').hide();
                $('.autowrite').hide();
                var xfmc = row.xfmc;
                var selectIndex = -1;
                var options = $("#xfsh").find("option");
                for (var j = 0; j < options.size(); j++) {
                    var text = $(options[j]).text();                  
                    if (text == xfmc) {
                        selectIndex = j;                        
                        break;
                    }
                }
                $("#xfsh").find("option").eq(selectIndex).attr("selected", true);
                var kpdmc = row.kpdmc;
                selectIndex = -1;               
                var xfid =  $('#xfsh option:selected').val();
                var skpid = $("#kpddm");
                $("#kpddm").empty();
                $.ajax({
                    url:"fpkc/getKpd",
                    data:{"xfid":xfid},
                    success:function(data){
                        for(var i=0;i<data.length;i++){
                            if(data[i].skpid != row.skpid){
                                var option = $("<option>").text(data[i].kpdmc).val(data[i].skpid);
                                skpid.append(option);
                            }
                            
                        }
                    }
                    
                });
                var option = $("<option selected>").text(kpdmc).val(row.skpid);
                skpid.append(option);
                var fpzlmc = row.fpzlmc;
                var selectIndex = -1;
                var options = $("#fplx").find("option");
                for (var j = 0; j < options.size(); j++) {
                    var text = $(options[j]).text();                  
                    if (text == fpzlmc) {
                        selectIndex = j;                        
                        break;
                    }
                }
                $("#fplx").find("option").eq(selectIndex).attr("selected", true);
                el.$fpdm.val(row.fpdm);
                el.$fphms.val(row.fphms);
                el.$fphmz.val(row.fphmz);
                el.$modalHongchong.modal('open');
                ur =_this.config.xgUrl + '?id=' + row.id;                
            });
            // 删除
            t.on('click', 'a.shanchu', function () {
                  var da = t.row($(this).parents('tr')).data();
                  $('#my-confirm').modal({
                      relatedTarget: this,
                      onConfirm: function(options) {                    
                          _this.sc(da);
                      },
                      onCancel: function() {
                     
                      }
                  });
            });
            return t;
        },
        /**
         * search action
         */
        search_ac: function () {
            var _this = this;
            el.$jsSearch.on('click', function (e) {
                $('#searchbz').val("1");
                e.preventDefault();
                loaddata = true;
                _this.tableEx.ajax.reload();
            });
        },
        find_mv:function(){
            var _this = this;
            $('#searchButton').on('click',function(e){
                $('#searchbz').val("0");
                e.preventDefault();
                loaddata = true;
                _this.tableEx.ajax.reload();
            })
        },
        
        add:function(){
            // 新增
            var _this = this;
            el.$jsAdd.on('click', el.$jsAdd, function () {
                 _this.resetForm();
                 $('#tablediv').hide();
                 $("#xfsh").find("option").eq(0).attr("selected", true);
                 $("#fplx").find("option").eq(0).attr("selected", true);
                 $("#kpddm").empty(); 
                 ur = _this.config.xzUrl;
                el.$modalHongchong.modal('toggle');
            });
        },
        
        autoWrite:function(){
            $('.autowrite').on('click',$('.autowrite'),function(e){
                var skpid = $('#kpddm').val();
                if(skpid==''||skpid==null){
                    // $('#alert-msg').html("请先选择销方及开票点！");
                    // $('#my-alert').modal('open');
                    swal("请先选择销方及开票点！");
                }else{
                    e.preventDefault();  
                    tb.ajax.reload();
                    $('#formdiv').hide();
                    $('#tablediv').show();
                }
                
            });         
        },
        
        retu:function(){
            $('.js-return').on('click',$('.js-return'),function(){
                $('#tablediv').hide();
                $('#formdiv').show();
            });         
        },
        /**
         * 新增保存
         */
        saveAllKc:function(){
            $('#autoKc').validator({
                submit:function(){
                    var len = $("#jsNewTable").children("tr").length;
                    $('.confirm').attr('disabled',"disabled");
                    if(len<1){
                        // $('#alert-msg').html("没有取到数据不能保存,请先检查开票通是否启动！");
            //          $('#my-alert').modal('open');
                        swal("没有取到数据不能保存,请先检查开票通是否启动！");
                        return false;
                    }else{
                        var data = $('#autoKc').serialize();
                        $.ajax({
                            url:'fpkc/saveAllkc',
                            data:data,
                            method: 'POST',
                            success:function(data){
                                 if(data.success){
                                    $('.confirm').removeAttr('disabled');
                                     el.$modalHongchong.modal('close'); // close
                                     $('#alert-msg').html(data.msg);
                                     $('#my-alert').modal('open');
                                     _this.tableEx.ajax.reload();
                                 }
                             }
                        })
                    }
                    return false;
                }
            })
        },
       save:function(){
           var _this = this;
           el.$jsForm.validator({
               submit: function () {
                var fpdm = $("#fpdm").val().trim();
                var fphms = $("#fphms").val().trim();          
                   var fphmz = $("#fphmz").val().trim();
                   var formValidity = this.isFormValid();
                   $('.confirm').attr('disabled',"disabled");
                   if (formValidity) {
                    if(parseInt(fphms)>parseInt(fphmz)){
               //           $('#alert-msg').html("起始号码大于终止号码，请重新输入！");
                        // $('#my-alert').modal('open');
                        swal("起始号码大于终止号码，请重新输入！");
                        return false;
                       }
                       var data = el.$jsForm.serialize(); // get form data
                       $.ajax({
                           url: ur,
                           data: data,
                           method: 'POST',
                           success: function (data) {                               
                               if (data.success) {
                                    $('.confirm').removeAttr('disabled');
                                   el.$modalHongchong.modal('close'); // close
                          //          $('#alert-msg').html(data.msg);
                                   // $('#my-alert').modal('open');
                                   swal(data.msg);
                                   _this.tableEx.ajax.reload();
                               }else{
                           //           $('#alert-msg').html(data.msg);
                                    // $('#my-alert').modal('open');  
                                    swal(data.msg);                                
                               }                             
                           },
                           error: function () {
                       //           $('#alert-msg').html("保存失败，请检查！");
                                // $('#my-alert').modal('open');
                                swal("保存失败，请检查！");
                           }
                       });
                       return false;
                   } else {
               //           $('#alert-msg').html("数据验证失败，请检查！");
                        // $('#my-alert').modal('open');
                        swal("数据验证失败，请检查！");
                   }
               }
           });
       },
        
        /**
         * 删除
         */
        sc: function (da) {
               var _this = this;
               $('.confirm').attr('disabled',"disabled");
            $.ajax({
                url: _this.config.scUrl,
                data: {"id":da.id},
                success: function (data) {
                    if (data.success) {
            //          $('#alert-msg').html(data.msg);
                        // $('#my-alert').modal('open');
                        $('.confirm').removeAttr('disabled');
                        swal(data.msg);
                         _this.tableEx.ajax.reload(); // reload table 
                    } else {    
            //          $('#alert-msg').html(data.msg);
                        // $('#my-alert').modal('open'); 
                        swal(data.msg);                    
                    }                                   
                },
                error: function () {
        //          $('#alert-msg').html("删除失败，请检查！");
                    // $('#my-alert').modal('open');
                    swal("删除失败，请检查！");
                }
            });
                
        },
        resetForm: function () {
            el.$jsForm[0].reset();
        },
        modalAction: function () {
            var _this = this;
            /*el.$modalHongchong.on('closed.modal.amui', function () {
                el.$jsForm0[0].reset();
            });*/
            el.$jsClose.on('click', function () {
                el.$modalHongchong.modal('close');
            });
        },
        init: function () {
            var _this = this;
            _this.tableEx = _this.dataTable(); // cache variable
            _this.search_ac();
            _this.add();
            _this.save();
            _this.modalAction(); // hidden action
            _this.find_mv();
            _this.autoWrite();
            _this.retu();
            _this.saveAllKc();
        }
    };
    action.init();
});