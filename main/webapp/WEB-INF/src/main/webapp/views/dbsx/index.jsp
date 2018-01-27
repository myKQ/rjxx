<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html class="no-js">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>待办事项</title>
<meta name="description" content="待办事项">
<meta name="keywords" content="待办事项">
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
<link rel="stylesheet" href="css/main.css" />
<link rel="stylesheet" href="assets/css/app.css" />
<script src="assets/js/loading.js"></script>
<link rel="stylesheet"
	href="plugins/jquery.jqplot.1.0.8/dist/jquery.jqplot.min.css" />
<link rel="stylesheet"
	href="plugins/jquery.jqplot.1.0.8/dist/jquery.jqplot.css" />
<style type="text/css">
.plane {
	text-align: center;
	padding-top: 30px;
	font-size: 32px
}

.dbsl {
	font-size: 20px;
	color: red;
	font-size: 32px
}
</style>
</head>
<body>
	<div class="am-g tpl-g">
		<div class="row-content am-cf">
			<div class="row">
				<div class="am-u-sm-12 am-u-md-12 am-u-lg-12">
					<div class="am-cf admin-main">
						<div class="admin-content">
							<div class="am-cf am-padding">
								<div class="am-fl am-cf">
									<strong id="yjcd" class="am-text-primary am-text-lg"></strong> / <strong id="ejcd"></strong>
								</div>
							</div>
							<hr />

							<div class="widget-body  am-fr">
							<ul class="am-avg-sm-1 am-avg-md-6 am-margin am-text-center">
							    <c:if test="${lrkpd==1}">
								<li class="am-dropdown tpl-dropdown">
									<a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #3F51B5;">
											<i class="am-icon-list-alt am-icon-lg" data="<%=request.getContextPath()%>/lrkpd" onclick="jump(this)">
												<c:if test="${lrkpddb==1 }"><span class="dian"></span></c:if>
											</i>		
											<br>
											录入开票单
										</div>
									</a
								></li>
								</c:if>
								<c:if test="${kpdsh==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size:2.5rem;color:#AAAAFF">
											<i class="am-icon-check-square am-icon-lg" data="<%=request.getContextPath()%>/kpdsh" onclick="jump(this)">
											<c:if test="${kpdshdb==1 }"><span class="dian"></span></c:if></i>
											<br>
											开票单审核
										</div>
								</a></li></c:if>
								<c:if test="${fpkj==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #79FF79">
											<i class="am-icon-print am-icon-lg" data="<%=request.getContextPath()%>/kp" onclick="jump(this)">
											<c:if test="${fpkjdb==1 }"><span class="dian"></span></c:if></i>
											<br>发票开具
										</div>
								</a></li></c:if>
								<c:if test="${fphc==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #A3D1D1">
											<i class="am-icon-reply am-icon-lg" data="<%=request.getContextPath()%>/fphc" onclick="jump(this)"></i>
											<br> 发票红冲
										</div>
								</a></li></c:if>
								<c:if test="${fphk==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #C7C7E2">
											<i class="am-icon-random am-icon-lg" data="<%=request.getContextPath()%>/fphk" onclick="jump(this)"></i><br>
											发票换开
										</div>
								</a></li></c:if>
                                <c:if test="${fpzf==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #FFBD9D">
											<i class="am-icon-trash am-icon-lg"  data="<%=request.getContextPath()%>/fpzf" onclick="jump(this)"></i><br>
											发票作废
										</div>
								</a></li></c:if>
								<c:if test="${fpck==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #95CACA">
											<i class="am-icon-refresh am-icon-lg"  data="<%=request.getContextPath()%>/fpck" onclick="jump(this)"></i><br>
											发票重开
										</div>
								</a></li></c:if>
								<c:if test="${fpcd==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #B8B8DC">
											<i class="am-icon-retweet am-icon-lg"  data="<%=request.getContextPath()%>/fpcd" onclick="jump(this)"></i><br>
											发票重打
										</div>
								</a></li></c:if>
								<c:if test="${fpfs==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color:  #B3D9D9">
											<i class="am-icon-envelope am-icon-lg"  data="<%=request.getContextPath()%>/yjfs" onclick="jump(this)"></i><br>
											发票发送
										</div>
								</a></li></c:if>
								<c:if test="${fpyj==1}">
								<li><a href="#" class="am-text-success">
										<div style="font-size: 2.5rem; color: #BBFFBB">
											<i class="am-icon-send am-icon-lg"  data="<%=request.getContextPath()%>/fpyj" onclick="jump(this)"></i><br>
											发票邮寄
										</div>
								</a></li></c:if>
							</ul>
							</div>
							<hr />
							<!-- 折线图开始 -->
							<div class="am-u-sm-12" style="padding-left: 20px">
								<div id="chart" style="width: 1000px; height: 400px"></div>
							</div>
							<!-- 折线图结束 -->
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
	</div>
	<a href="#"
		class="am-icon-btn am-icon-th-list am-show-sm-only admin-menu"
		data-am-offcanvas="{target: '#admin-offcanvas'}"></a>
	<div data-am-widget="gotop" class="am-gotop am-gotop-fixed">
		<a href="#top" title="回到顶部"> <i
			class="am-gotop-icon am-icon-hand-o-up"></i>
		</a>
	</div>
	<script src="assets/js/jquery.min.js"></script>
	<script src="assets/js/amazeui.min.js"></script>
	<script
		src="plugins/datatables-1.10.10/media/js/jquery.dataTables.min.js"></script>
	<script src="assets/js/amazeui.datatables.js"></script>
	<script src="assets/js/amazeui.tree.min.js"></script>
	<script src="plugins/jquery.jqplot.1.0.8/dist/jquery.jqplot.min.js"></script>
	<script src="plugins/jquery.jqplot.1.0.8/dist/excanvas.min.js"></script>
	<script src="plugins/jquery.jqplot.1.0.8/dist/excanvas.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.pieRenderer.min.js"></script>
	<script src="plugins/jquery.jqplot.1.0.8/dist/jqplot.pieRenderer.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.canvasAxisTickRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.canvasAxisLabelRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.canvasTextRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.enhancedLegendRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.dateAxisRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.highlighter.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.pointLabels.min.js"></script>
	<script src="plugins/jquery.jqplot.1.0.8/dist/jqplot.cursor.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.categoryAxisRenderer.min.js"></script>
	<script
		src="plugins/jquery.jqplot.1.0.8/dist/jqplot.barRenderer.min.js"></script>
	<script src="assets/js/app.js"></script>
	<script src="assets/js/format.js"></script>
	<script src="assets/js/fpcx_4.js"></script>
	<script>
		$(function() {
			var line1 = new Array();
			var ticks = new Array();
			$
					.ajax({
						type : "POST",
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						url : 'dbsx/getPlot',
						success : function(result) {
							var i = 0;
							for (key in result) {
								ticks[i] = key;
								line1[i] = result[key];
								i++;
							}
							//plot开始
							$('#chart')
									.jqplot(
											[ line1 ],
											{
												title : '近一个月已办事项统计',
												//seriesColors:["#2894FF","#FFE153"],
												//varyBarColor: true,
												seriesDefaults : {
													pointLabels : {
														show : true
													},
													shadow : false,
													showMarker : true
												// 是否强调显示图中的数据节点
												//renderer:$.jqplot.BarRenderer,      //放开的话为柱状图
												/* rendererOptions: {
													barWidth: 18,
													barPadding: 8
												} */
												},
												axes : {
													xaxis : {
														label : '日期',
														tickRenderer : $.jqplot.CanvasAxisTickRenderer,
														renderer : $.jqplot.CategoryAxisRenderer,
														ticks : ticks,
														showTicks : true, // 是否显示刻度线以及坐标轴上的刻度值  
														showTickMarks : true, //设置是否显示刻度
														tickOptions : {
															show : true,
															fontSize : '14px',
															fontFamily : 'tahoma,arial,"Hiragino Sans GB",宋体b8b体,sans-serif',
															angle : -30,
															showLabel : true, //是否显示刻度线以及坐标轴上的刻度值
															showMark : false,//设置是否显示刻度
															showGridline : false
														// 是否在图表区域显示刻度值方向的网格
														}
													},
													yaxis : {
														label : '已办事项数量',
														show : true,
														showTicks : true, // 是否显示刻度线以及坐标轴上的刻度值  
														showTickMarks : true, //设置是否显示刻度
														autoscale : true,
														borderWidth : 1,
														tickOptions : {
															show : true,
															showLabel : true,
															showMark : true,
															showGridline : true
														}
													}
												}
											});
							//plot结束
						}
					});

			/* $('#chart').jqplot([line1],{
				title:'近一周代办事项情况',
				 seriesDefaults:{
					pointLabels: { show: true },
					shadow: false,
					showMarker: true, // 是否强调显示图中的数据节点
					renderer:$.jqplot.BarRenderer,
					rendererOptions: {
						barWidth: 60,
						barMargin: 60
					}
				}, 		 
				axes:{
					xaxis:{
						label:'日期',
						renderer:$.jqplot.CategoryAxisRenderer,
						ticks:ticks,
						showTicks: true,        // 是否显示刻度线以及坐标轴上的刻度值  
						showTickMarks: true,    //设置是否显示刻度
						tickOptions: {
						     show: true,
						     fontSize: '14px',
						     fontFamily: 'tahoma,arial,"Hiragino Sans GB",宋体b8b体,sans-serif',
						     showLabel: true, //是否显示刻度线以及坐标轴上的刻度值
						     showMark: false,//设置是否显示刻度
						     showGridline: false // 是否在图表区域显示刻度值方向的网格
					    }
					},
					yaxis: {
						show: true,
						showTicks: false,        // 是否显示刻度线以及坐标轴上的刻度值  
						showTickMarks: false,     //设置是否显示刻度
						autoscale: true,
						borderWidth: 1,
						tickOptions: {
						     show: true,
						     showLabel: false,
						     showMark: false,
						     showGridline: true
						}
					}
				}
			}); */
		});

		function jump(da) {
			var v_id = $(da).attr('data');
			$(".ejcd", parent.document).css('background', 'none');
			var divs = $('.ejcd', parent.document);
			for (var i = 0; i < divs.length; i++) {
				if ($(divs[i]).attr('data') == v_id) {
					$(divs[i]).css("background-color", "#f2f6f9");
					$("#cd1",parent.document).val($(divs[i]).attr("dele"));
					$("#cd2",parent.document).val($(divs[i]).attr("parname"));
				}
			}
			$("#mainFrame", parent.document).attr("src", v_id);
		}
	</script>
</body>
</html>
