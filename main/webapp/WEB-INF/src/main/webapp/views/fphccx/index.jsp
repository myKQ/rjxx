<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html class="no-js">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>红冲发票查询</title>
<meta name="description" content="红冲发票查询">
<meta name="keywords" content="红冲发票查询">
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
<script src="assets/js/loading.js"></script>
<style type="text/css">
     .top-position {margin-top:8px}
     .data-ctr {
	  text-align: center;
	}
</style>
</head>
<body>
	<div class="row-content am-cf">
		<div class="row">
			<div class="am-u-sm-12 am-u-md-12 am-u-lg-12">
				<div class="widget am-cf">
					<div class="am-cf admin-main">
						<!-- content start -->
						<div class="admin-content">
							<div class="am-cf widget-head">
								<div class="widget-title am-cf">
								<br>
									<strong class="am-text-primary am-text-lg">查询统计</strong> / <strong>红字发票查询</strong>
									<button class="am-btn am-btn-success am-fr"
										data-am-offcanvas="{target: '#doc-oc-demo3'}">更多查询</button>
								</div>
								<!-- 侧边栏内容 -->
								<div id="doc-oc-demo3" class="am-offcanvas">
									<div class="am-offcanvas-bar am-offcanvas-bar-flip">
										<form class="js-search-form am-form">
											<div class="am-offcanvas-content">
												<div class="am-form-group">
													<label for="xfmc" class="am-u-sm-4 am-form-label">销方名称</label>
													<div class="am-u-sm-8">
														<select id="s_xfid" name="xfid"
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
													<label for="kpdmc" class="am-u-sm-4 am-form-label">开票点</label>
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
													<label for="fpzldm" class="am-u-sm-4 am-form-label">发票种类</label>
													<div class="am-u-sm-8">
														<select id="s_fpzl" name="fpzl"
															data-am-selected="{btnSize: 'sm'}">
															<option value="">----请选择----</option>
															<c:forEach items="${fpzlList}" var="item">
																<option value="${item.fpzldm}">${item.fpzlmc}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="ddh" class="am-u-sm-4 am-form-label">订单号</label>
													<div class="am-u-sm-8">
														<input type="text" class="am-form-field" id="s_ddh"
															name="s_ddh" placeholder="请输入订单号" />
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="gfmc" class="am-u-sm-4 am-form-label">购方名称</label>
													<div class="am-u-sm-8">
														<input type="text" class="am-form-field" id="s_gfmc"
															name="s_gfmc" placeholder="请输入购方名称" />
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="kprqq" class="am-u-sm-4 am-form-label">红冲日期</label>
													<div class="am-input-group am-datepicker-date am-u-sm-8"
														data-am-datepicker="{format: 'yyyy-mm-dd'}">
														<input type="text" id="s_kprqq" class="am-form-field"
															placeholder="开始时间" readonly> <span
															class="am-input-group-btn am-datepicker-add-on">
															<button class="am-btn am-btn-default" type="button">
																<span class="am-icon-calendar"></span>
															</button>
														</span>
													</div>
												</div>
											</div>
											<div class="am-offcanvas-content top-position">
												<div class="am-form-group">
													<label for="kprqz" class="am-u-sm-4 am-form-label">——</label>
													<div class="am-input-group am-datepicker-date am-u-sm-8"
														data-am-datepicker="{format: 'yyyy-mm-dd'}">
														<input type="text" id="s_kprqz" class="am-form-field"
															placeholder="截止时间" readonly> <span
															class="am-input-group-btn am-datepicker-add-on">
															<button class="am-btn am-btn-default" type="button">
																<span class="am-icon-calendar"></span>
															</button>
														</span>
													</div>
												</div>
											</div>						
											<div style="padding: 32px;">
												<button type="button"
													class="js-search am-btn am-btn-default am-btn-success data-back">
													<span class="am-icon-search-plus"></span> 查询
												</button>
											</div>
										</form>
									</div>
								</div>
							</div>
							<div class="am-g am-padding-top">
								<form class="am-form">
									<div class="am-u-sm-12 am-u-md-6 am-u-lg-6">
										<div class="am-form-group">
											<div class="am-btn-toolbar">
												<div class="am-btn-group am-btn-group-xs">
													<input type="hidden" id="searchbz">
												</div>
											</div>
										</div>
									</div>
									<div class="am-u-sm-12 am-u-md-6 am-u-lg-3">
										<div class="am-form-group tpl-table-list-select">
											<select data-am-selected="{btnSize: 'sm'}" id="s_mainkey">
												<option value="ddh">订单号</option>
												<option value="gfmc">购方名称</option>
											</select>
										</div>
									</div>
									<div class="am-u-sm-12 am-u-md-12 am-u-lg-3">
										<div
											class="am-input-group am-input-group-sm tpl-form-border-form cl-p">
											<input type="text" class="am-form-field" id="searchValue"> <span
												class="am-input-group-btn">
												<button id="jssearch"
													class="am-btn am-btn-default am-btn-success tpl-table-list-field am-icon-search"
													type="button"></button>
											</span>
										</div>
									</div>
								</form>
							</div>
							<hr />
							<div class="am-u-sm-12">
								<div class="am-scrollable-horizontal">
									<table
										class="js-table  am-table am-table-bordered am-table-striped am-text-nowrap">
										<thead>
											<tr>
												<th>序号</th>
												<th>操作</th>
												<th>订单号</th>
												<th>发票种类</th>
												<th>购方名称</th>
												<th>发票代码</th>
												<th>发票号码</th>
												<th>原发票代码</th>
												<th>原发票号码</th>
												<th class="data-ctr">金额</th>
												<th class="data-ctr">税额</th>
												<th class="data-ctr">价稅合计</th>
												<th>红冲日期</th>
												<th>开票人</th>
											</tr>
										</thead>
										<tbody>

										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- content end -->

						<!-- model -->
						<div class="am-modal am-modal-no-btn" tabindex="-1" id="hongchong">
							<div class="am-modal-dialog">
								<div class="am-modal-hd">
									红字发票详情 <a href="javascript: void(0)"
										class="am-close am-close-spin" data-am-modal-close>&times;</a>
								</div>
								<div class="am-modal-bd">
									<hr />
									<form action="#" class="js-form-0  am-form am-form-horizontal">
										<div class="am-g">
											<div class="am-u-sm-12">
												<div class="am-form-group">
													<label for="hc_fpdm" class="am-u-sm-4 am-form-label">发票代码</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_fpdm" name="hc_fpdm"
															placeholder="" readonly /> <input type="hidden"
															name="id" />
													</div>
												</div>
												<div class="am-form-group">
													<label for="hc_fphm" class="am-u-sm-4 am-form-label">发票号码</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_fphm" name="hc_fphm"
															placeholder="" readonly />
													</div>
												</div>
												<div class="am-form-group">
													<label for="hc_je" class="am-u-sm-4 am-form-label">金额</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_je" name="hc_je" placeholder=""
															readonly />
													</div>
												</div>

											</div>
											<div class="am-u-sm-12">
												<div class="am-form-group">
													<label for="hc_se" class="am-u-sm-4 am-form-label">税额</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_se" name="hc_se" placeholder=""
															readonly />
													</div>
												</div>

												<div class="am-form-group">
													<label for="hc_gfmc" class="am-u-sm-4 am-form-label">购方名称</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_gfmc" name="hc_gfmc"
															placeholder="" readonly />
													</div>
												</div>
												<div class="am-form-group">
													<label for="hc_yfpdm" class="am-u-sm-4 am-form-label">原发票代码</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_yfpdm" name="hc_yfpdm"
															placeholder="" readonly />
													</div>
												</div>
												<div class="am-form-group">
													<label for="hc_yfphm" class="am-u-sm-4 am-form-label">原发票号码</label>
													<div class="am-u-sm-8">
														<input type="text" id="hc_yfphm" name="hc_yfphm"
															placeholder="" readonly />
													</div>
												</div>
											</div>
											<div class="am-u-sm-12">
												<div class="am-form-group">
													<div class="am-u-sm-12  am-text-center">
														<button type="button"
															class="js-close  am-btn am-btn-danger">关闭</button>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>

						<!-- loading do not delete this -->
						<div
							class="js-modal-loading  am-modal am-modal-loading am-modal-no-btn"
							tabindex="-1">
							<div class="am-modal-dialog">
								<div class="am-modal-hd">正在载入...</div>
								<div class="am-modal-bd">
									<span class="am-icon-spinner am-icon-spin"></span>
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
	<script src="assets/js/fphccx.js"></script>

</body>
</html>