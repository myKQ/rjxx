/**
 * feel
 */
$(function () {
    "use strict";
    var ur ;
    var el = {
    	$jkTable: $('#dyzytable'),//库存table   
        $jsRefresh: $('#jsSearch'),//查询按钮
        $jkLoading: $('.js-modal-loading')//输在载入特效
    };
    var loaddata = false;
    var action = {
        tableEx: null, // cache dataTable
        config: {
            getUrl: 'fpkc/getItems2'        
        },
        dataTable: function () {
            var _this = this;
            var t = el.$jkTable
                .DataTable({
                    "processing": true,
                    "serverSide": true,
                    ordering: false,
                    searching: false,
                    "ajax": {
                        url: _this.config.getUrl,
                        type: 'POST',
                        data: function (d) {
                        	var bz = $('#searchbz').val();
                            d.loaddata = loaddata;
                        	if(bz=='1'){
                        		 d.xfid = $('#s_xfid').val();
                                 d.skpid = $('#s_skpid').val();
                                 d.fplx = $('#s_fplx').val();
                                 d.fpsl = $('#s_fpsl').val();

                        	}else{
                        		var item = $('#s_mainkey').val();
                        		if(item=='xfsh'){
                        			d.xfsh = $('#searchValue').val();
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
                        {"data": "xfmc"},
                        {"data": "xfsh"},
                        {"data": "kpdmc"},
                        {"data":"fpzlmc"},                   
                        {"data": "kyl"}
                        ]
                });
            	   
            t.on('draw.dt', function (e, settings, json) {
                var x = t, page = x.page.info().start; // 设置第几页
                t.column(0).nodes().each(function (cell, i) {
                    cell.innerHTML = page + i + 1;
                });
            });                                   
            return t;
        },
        /**
         * search action
         */
        refresh_ac: function () {
            var _this = this;
            el.$jsRefresh.on('click', function (e) {
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
        init: function () {
            var _this = this;
            _this.tableEx = _this.dataTable(); // cache variable
            _this.refresh_ac();
            _this.find_mv();
        }
    };
    action.init();
    

});