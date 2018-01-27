<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html class="no-js">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>发票库存管理</title>
<meta name="description" content="发票库存管理">
<meta name="keywords" content="发票库存管理">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="renderer" content="webkit">
<meta http-equiv="Cache-Control" content="no-siteapp" />
<link rel="icon" type="image/png" href="../../assets/i/favicon.png">
<link rel="apple-touch-icon-precomposed"
	href="../../assets/i/app-icon72x72@2x.png">
<meta name="apple-mobile-web-app-title" content="Amaze UI" />
<link rel="stylesheet" href="assets/css/amazeui.min.css" />
<link rel="stylesheet" href="assets/css/admin.css">
<link rel="stylesheet" href="assets/css/amazeui.tree.min.css">
<link rel="stylesheet" href="assets/css/amazeui.datatables.css" />
<link rel="stylesheet" href="assets/css/app.css">
<link rel="stylesheet" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="assets/css/sweetalert.css">
<script src="assets/js/loading.js"></script>
<style type="text/css">
.top-position {
	margin-top: 8px
}
</style>
</head>
<body>
	<div class="row-content am-cf">
		<div class="row">
			<div class="am-u-sm-12 am-u-md-12 am-u-lg-12">
				<div class="widget am-cf">
					<div class="am-cf admin-main">
						<div class="admin-content">
							<div class="am-cf widget-head">
								<div class="widget-title am-cf">
									<br> <strong id="yjcd" class="am-text-primary am-text-lg"></strong>
									/ <strong id="ejcd"></strong>
									<button class="am-btn am-btn-success am-fr"
										data-am-offcanvas="{target: '#doc-oc-demo3'}">更多查询</button>
								</div>
								<div id="doc-oc-demo3" class="am-offcanvas">
									<div class="am-offcanvas-bar am-offcanvas-bar-flip">
										<form class="js-search-form am-form">
											<div class="am-offcanvas-content">
												<div class="am-form-group">
													<label for="s_xfmc" class="am-u-sm-4 am-form-label">销方名称</label>
													<div class="am-u-sm-8">
														<select id="xfid" name="xfid"
															data-am-selected="{btnSize: 'sm'}">
															<option value="">请选择销方</option>
															<c:forEach items="${xfList}" var="xf">
																<option value="${xf.id}">${xf.xfmc}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="s_kpdmc" class="am-u-sm-4 am-form-label">开票点</label>
													<div class="am-u-sm-8">
														<select id="s_skpid" name="skpid"
															data-am-selected="{btnSize: 'sm'}">
															<option value="">请选择开票点</option>
															<c:forEach items="${skpList}" var="skp">
																<option value="${skp.id}">${skp.kpdmc}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="s_fplx" class="am-u-sm-4 am-form-label">发票种类</label>
													<div class="am-u-sm-8">
														<select id="cfplx" name="fpzldm"
															data-am-selected="{btnSize: 'sm'}">
															<option value="">请选择发票种类</option>
															<c:forEach items="${fplxList}" var="item">
																<option value="${item.fpzldm}">${item.fpzlmc}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="s_fpdm" class="am-u-sm-4 am-form-label">发票代码</label>
													<div class="am-u-sm-8">
														<input type="text" id="cfpdm" name="fpdm"
															class="am-form-field" placeholder="发票代码" />
													</div>
												</div>
											</div>
											<div style="padding: 32px;">
												<button type="button" id="jsSearch"
													class="am-btn am-btn-default am-btn-success data-back">
													<span class="am-icon-search-plus"></span> 查询
												</button>
											</div>
										</form>
									</div>
								</div>
							</div>
							<div class="am-g am-padding-top">
								<div class="am-u-sm-12 am-u-md-6 am-u-lg-6">
									<div class="am-form-group">
										<div class="am-btn-toolbar">
											<div class="am-btn-group am-btn-group-xs">
												<input type="hidden" id="searchbz">
												<button class="am-btn am-btn-primary" id="jsAdd">
													&nbsp;录入&nbsp;</button>
											</div>
										</div>
									</div>
								</div>
								<div class="am-u-sm-12 am-u-md-6 am-u-lg-3">
									<div class="am-form-group tpl-table-list-select">
										<select data-am-selected="{btnSize: 'sm'}" id="s_mainkey">
											<option value="fpdm">发票代码</option>
										</select>
									</div>
								</div>
								<div class="am-u-sm-12 am-u-md-12 am-u-lg-3">
									<div
										class="am-input-group am-input-group-sm tpl-form-border-form cl-p">
										<input type="text" class="am-form-field" id="searchValue">
										<span class="am-input-group-btn">
											<button id="searchButton"
												class="am-btn am-btn-default am-btn-success tpl-table-list-field am-icon-search"
												type="button"></button>
										</span>
									</div>
								</div>
								<div class="am-u-sm-12">
									<div>
										<table id="search-table"
											class="js-table am-table am-table-bordered am-table-compact am-table-striped am-text-nowrap">
											<thead>
												<tr>
													<th>序号</th>
													<th>操作</th>
													<th>销方名称</th>
													<th>销方税号</th>
													<th>开票点名称</th>
													<th>发票类型</th>
													<th>发票代码</th>
													<th>起始发票号码</th>
													<th>终止发票号码</th>
													<th>库存(张)</th>
													<th>剩余库存(张)</th>
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
						</div>

						<div class="am-modal am-modal-no-btn" tabindex="-1" id="hongchong">
							<div class="am-modal-dialog" style="height: 320px; width: 800px">
								<div class="am-tabs" data-am-tabs>
									<div class="am-tabs-nav am-nav am-nav-tabs">
										<label>发票库存管理</label>
									</div>
									<div class="am-tabs-bd">
										<div class="am-tab-panel am-in am-active" id="tab1">
											<div class="am-modal-bd">
												<div class="am-g" id="formdiv">
													<form class="js-form-kc am-form">
														<div class="am-u-sm-12">
															<table class="am-table am-table-bordered">
																<tr>
																	<td><font color="red">*</font>销方名称：</td>
																	<td><select id="xfsh" name="xfid"
																		class="am-form-field" required onchange="getKpd()">
																			<option value="">---请选择---</option>
																			<c:forEach items="${xfList}" var="xf">
																				<option value="${xf.id}">${xf.xfmc}</option>
																			</c:forEach>
																	</select></td>
																	<td><font color="red">*</font>开票点名称：</td>
																	<td><select id="kpddm" name="skpid"
																		class="am-form-field" required>
																	</select></td>
																</tr>
																<tr>
																	<td><font color="red">*</font>发票种类：</td>
																	<td><select id="fplx" name="fpzldm"
																		class="am-form-field" required>
																			<option value="">---请选择---</option>
																			<c:forEach items="${fplxList}" var="item">
																				<option value="${item.fpzldm}">${item.fpzlmc}</option>
																			</c:forEach>
																	</select></td>
																	<td><font color="red">*</font>发票代码：</td>
																	<td><input type="text" id="fpdm" name="fpdm"
																		maxlength="12" pattern="^\d{10,12}$"
																		placeholder="请输入发票代码" class="am-form-field" required /></td>
																</tr>
																<tr>
																	<td><font color="red">*</font>发票号码：</td>
																	<td><input type="text" id="fphms" name="fphms"
																		maxlength="10" pattern="^\d{8}$" placeholder="请输入起始号码"
																		class="am-form-field" required /></td>
																	<td><font color="red">*</font>——</td>
																	<td><input type="text" id="fphmz" name="fphmz"
																		maxlength="10" pattern="^\d{8}$" placeholder="请输入截止号码"
																		class="am-form-field" required /></td>
																</tr>
															</table>
														</div>
														<div class="am-u-sm-12">
															<div class="am-form-group">
																<div class="am-u-sm-12  am-text-center">
																	<button type="submit"
																		class="am-btn am-radius am-btn-success">保存</button>
																	<button type="button"
																		class="js-close am-btn am-radius am-btn-warning">取消</button>
																	<button type="button"
																		class="autowrite am-btn am-radius am-btn-success">自动读取</button>
																</div>
															</div>
														</div>
													</form>
												</div>
												<div class="am-u-sm-12" id="tablediv">
													 <form class="am-form" id="autoKc"> 
														<div class="am-u-sm-12">
															<table class="am-table am-table-bordered am-text-nowrap"
																id="jsNewTable">
																<thead>
																	<tr>
																		<th>销方名称</th>
																		<th>销方税号</th>
																		<th>开票点名称</th>
																		<th>发票种类</th>
																		<th>发票代码</th>
																		<th>起始发票号码</th>
																		<th>终止发票号码</th>
																		<th>剩余库存</th>
																	</tr>
																</thead>
																<tbody>
																	
																</tbody>
															</table>
														</div>
														<div class="am-u-sm-12">
															<div class="am-form-group">
																<div class="am-u-sm-12  am-text-center">
																	<button type="submit"
																		class="am-btn am-radius am-btn-success">保存</button>
																	<button type="button"
																		class="js-return am-btn am-radius am-btn-warning">返回</button>
																</div>
															</div>
														</div>
													 </form> 
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="am-modal am-modal-alert" tabindex="-1" id="my-alert">
							<div class="am-modal-dialog">
								<div class="am-modal-hd">提示</div>
								<div class="am-modal-bd" id="alert-msg"></div>
								<div class="am-modal-footer">
									<span class="am-modal-btn">确定</span>
								</div>
							</div>
						</div>
						<div class="am-modal am-modal-confirm" tabindex="-1"
							id="my-confirm">
							<div class="am-modal-dialog">
								<div class="am-modal-hd">提示</div>
								<div class="am-modal-bd">你确定要删除这条记录吗？</div>
								<div class="am-modal-footer">
									<span class="am-modal-btn" data-am-modal-cancel>取消</span> <span
										class="am-modal-btn" data-am-modal-confirm>确定</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<a href="#"
		class="am-icon-btn am-icon-th-list am-show-sm-only admin-menu"
		data-am-offcanvas="{target: '#admin-offcanvas'}"></a>

	<!--[if (gte IE 9)|!(IE)]><!-->
	<script src="assets/js/jquery.min.js"></script>
	<!--<![endif]-->
	<script src="assets/js/amazeui.min.js"></script>
	<script
		src="plugins/datatables-1.10.10/media/js/jquery.dataTables.min.js"></script>
	<script src="assets/js/amazeui.datatables.js"></script>
	<script src="assets/js/amazeui.tree.min.js"></script>
	<script src="assets/js/app.js"></script>
	<script src="assets/js/format.js"></script>
	<script src="assets/js/fpkc.js"></script>
	<script src="assets/js/sweetalert.min.js"></script>
	<script>
		function getKpd() {
			var xfid = $('#xfsh option:selected').val();
			var skpid = $("#kpddm");
			$("#kpddm").empty();
			$.ajax({
				url : "fpkc/getKpd",
				data : {
					"xfid" : xfid
				},
				success : function(data) {
					for (var i = 0; i < data.length; i++) {
						var option = $("<option>").text(data[i].kpdmc).val(
								data[i].skpid);
						skpid.append(option);
					}
				}

			});
		}
	</script>
</body>
</html>