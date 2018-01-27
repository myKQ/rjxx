package com.rjxx.taxeasy.controller;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rjxx.taxeasy.domains.Fpzl;
import com.rjxx.taxeasy.domains.Xf;
import com.rjxx.taxeasy.service.FpzlService;
import com.rjxx.taxeasy.service.KplsvoService;
import com.rjxx.taxeasy.vo.Fpnum;
import com.rjxx.taxeasy.vo.KplsVO;
import com.rjxx.taxeasy.vo.Slcxvo;
import com.rjxx.taxeasy.web.BaseController;
import com.rjxx.time.TimeUtil;

@Controller
@RequestMapping("/fytjbb")
public class FytjbbController extends BaseController {

	@Autowired
	private KplsvoService kvs;
	@Autowired
	private FpzlService fpzlService;

	@RequestMapping
	public String index() {
		List<Fpzl> fpzlList = fpzlService.findAllByParams(new HashMap<>());
		request.setAttribute("fpzlList", fpzlList);
		List<Xf> xfs = getXfList();
		request.setAttribute("xfs", xfs);
		return "fytjbb/index";
	}
	
	//取得每月各种发票的数量
	@RequestMapping(value = "/getfps")
	@ResponseBody
	public Map<String,Object> getFps(Integer xfid,String fpzl,String kprq,String kprqq,String kprqz){
		Map<String,Object> result = new HashMap<String,Object>();		
		String kprq1 = kprq;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		try{
			/*if (!kprq.contains("-")) {
				Date kprq2 = new Date(kprq);				
				kprq1 = sdf.format(kprq2);				
			}*/
			if(kprqz !=null && !"".equals(kprqz)){
				Date date = sdf.parse(kprqz);
				Calendar calender = Calendar.getInstance();
		        calender.setTime(date);
		        calender.add(Calendar.MONTH, 1);
		        kprqz = sdf.format(calender.getTime());
			}			
			Map params = new HashMap<>();
			params.put("gsdm", getGsdm());
			List<Xf> xfs = getXfList();
			if(xfs !=null && xfs.size()>0){
				params.put("xfs", xfs);
			}
			params.put("xfid", xfid);
			params.put("fpzl", fpzl);
			params.put("kprq", kprq1);
			params.put("kprqq", kprqq);
			params.put("kprqz", kprqz);
			List<Fpnum> slList = fpzlService.findGfpsl(params);
			Integer zspfs = slList.get(0).getFpnum();
			Integer fspfs = slList.get(1).getFpnum();
			Integer hjpfs = zspfs+fspfs;
			Integer zcpfs = slList.get(2).getFpnum();
			Integer hcpfs = slList.get(3).getFpnum();
			Integer hkpfs = slList.get(4).getFpnum();
			Integer zfpfs = slList.get(5).getFpnum();
			Integer ckpfs = slList.get(6).getFpnum();
			Integer cdpfs = slList.get(7).getFpnum();
			result.put("zspfs",zspfs);
			result.put("fspfs",fspfs);
			result.put("hjpfs",hjpfs);
			result.put("zcpfs",zcpfs);
			result.put("hcpfs",hcpfs);
			result.put("hkpfs",hkpfs);
			result.put("zfpfs",zfpfs);
			result.put("ckpfs",ckpfs);
			result.put("cdpfs",cdpfs);
			result.put("success",true);
		}catch(Exception e){
			e.printStackTrace();
			result.put("success",false);
		}		
		return result;
	}
	
	@RequestMapping(value = "/getje")
	@ResponseBody
	public Map<String,Object> getTjje(Integer xfid,Integer skpid,String fpzl,String kprq,String kprqq,String kprqz){
		Map<String,Object> result = new HashMap<String,Object>();
        if("".equals(kprq)||kprq==null){
        	if("".equals(kprqq)||kprqq==null){
        		result.put("data", new ArrayList<>());
            	return result;
        	}       	
		}
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        if(kprqz !=null && !"".equals(kprqz)){
        	try {
   			 Date date = sdf.parse(kprqz);
   			 Calendar calender = Calendar.getInstance();
   	         calender.setTime(date);
   	         calender.add(Calendar.MONTH, 1);
   	         kprqz = sdf.format(calender.getTime());
   		   } catch (ParseException e) {
   			  e.printStackTrace();
   		   }
        }		 
		Map params = new HashMap<>();
		params.put("gsdm", getGsdm());
		List<Xf> xfs = getXfList();
		if(xfs !=null && xfs.size()>0){
			params.put("xfs", xfs);
		}
		params.put("xfid", xfid);
		params.put("skpid", skpid);
		params.put("fpzl", fpzl);
		params.put("kprq", kprq);
		params.put("kprqq", kprqq);
		params.put("kprqz", kprqz);
		List<Slcxvo> tjList = fpzlService.findSpje(params);		
		result.put("data", tjList);
		return result;
	}

	/**
	 * init by month
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getList")
	@ResponseBody
	public Map getList(String kprq) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		if (null == kprq || "".equals(kprq)) {
			result.put("error", true);
			return result;
		}
		String kprq1 = kprq;
		if (!kprq.contains("-")) {
			Date kprq2 = new Date(kprq);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
			kprq1 = sdf.format(kprq2);
		}
		double je3 = 0.00, se3 = 0.00, jshj3 = 0.00, je1 = 0.00, se1 = 0.00, jshj1 = 0.00, je2 = 0.00, se2 = 0.00,
				jshj2 = 0.00;
		try {
			// 换开
			Map<String, Object> params = new HashMap<>();
			params.put("gsdm", getGsdm());
			params.put("kprq", kprq1);
			params.put("fpczlxdm", "13");
			List<KplsVO> ls3 = kvs.findAllByParams(params);
			if (ls3.size() > 0) {
				for (int i = 0; i < ls3.size(); i++) {
					je3 += ls3.get(i).getJe();
					se3 += ls3.get(i).getSe();
					jshj3 += ls3.get(i).getJshj();
				}
			}
			result.put("je3", getNumberFormat(je3));
			result.put("se3", getNumberFormat(se3));
			result.put("jshj3", getNumberFormat(jshj3));
			result.put("fpsl3", ls3.size());
			// 正常开具
			params.put("fpczlxdm", "11");
			List<KplsVO> ls1 = kvs.findAllByParams(params);
			if (ls1.size() > 0) {
				for (int j = 0; j < ls1.size(); j++) {
					je1 += ls1.get(j).getJe();
					se1 += ls1.get(j).getSe();
					jshj1 += ls1.get(j).getJshj();
				}
			}
			result.put("je1", getNumberFormat(je1));
			result.put("se1", getNumberFormat(se1));
			result.put("jshj1", getNumberFormat(jshj1));
			result.put("fpsl1", ls1.size());
			// 红冲
			params.put("fpczlxdm", "12");
			List<KplsVO> ls2 = kvs.findAllByParams(params);
			if (ls2.size() > 0) {
				for (int k = 0; k < ls2.size(); k++) {
					je2 += ls2.get(k).getJe();
					se2 += ls2.get(k).getSe();
					jshj2 += ls2.get(k).getJshj();
				}
			}
			result.put("je2", getNumberFormat(je2));
			result.put("se2", getNumberFormat(se2));
			result.put("jshj2", getNumberFormat(jshj2));
			result.put("fpsl2", ls2.size());

			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("failure", true);
			result.put("msg", "后台出现错误: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 得到前一月
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getPre")
	@ResponseBody
	public Map getPre(String kprq) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Date d = TimeUtil.getStringInDate(kprq, "yyyy-MM");
			d.setMonth(d.getMonth() - 1);
			String rq = TimeUtil.formatDate(d, "yyyy-MM");
			result.put("prerq", rq);
			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("failure", true);
			result.put("msg", "后台出现错误: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 得到后一月
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getLater")
	@ResponseBody
	public Map getLater(String kprq) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Date d = TimeUtil.getStringInDate(kprq, "yyyy-MM");
			d.setMonth(d.getMonth() + 1);
			String rq = TimeUtil.formatDate(d, "yyyy-MM");
			result.put("laterrq", rq);
			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("failure", true);
			result.put("msg", "后台出现错误: " + e.getMessage());
		}
		return result;
	}

	public void save() {
		/*
		 * Map<String, Object> result = new HashMap<String, Object>(); return
		 * new JsonView(result);
		 */
	}

	/**
	 * 将double类型数据保留两位小数并返回金钱格式
	 * 
	 * @param data
	 * @return
	 */
	public static String getNumberFormat(double data) {
		NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.CHINA);
		return nf.format(data).replace("￥", "");
	}

	@RequestMapping(value = "/export")
	@ResponseBody
	public Map export(String kprq) throws Exception {

		double je3 = 0.00, se3 = 0.00, jshj3 = 0.00, je1 = 0.00, se1 = 0.00, jshj1 = 0.00, je2 = 0.00, se2 = 0.00,
				jshj2 = 0.00;
		// 换开
		Map<String, Object> params = new HashMap<>();
		params.put("gsdm", getGsdm());
		params.put("kprq", kprq);
		params.put("fpczlxdm", "13");
		List<KplsVO> ls3 = kvs.findAllByParams(params);
		if (ls3.size() > 0) {
			for (int i = 0; i < ls3.size(); i++) {
				je3 += ls3.get(i).getJe();
				se3 += ls3.get(i).getSe();
				jshj3 += ls3.get(i).getJshj();
			}
		}
		// 正常开具
		params.put("fpczlxdm", "11");
		List<KplsVO> ls1 = kvs.findAllByParams(params);
		if (ls1.size() > 0) {
			for (int j = 0; j < ls1.size(); j++) {
				je1 += ls1.get(j).getJe();
				se1 += ls1.get(j).getSe();
				jshj1 += ls1.get(j).getJshj();
			}
		}
		// 红冲
		params.put("fpczlxdm", "12");
		List<KplsVO> ls2 = kvs.findAllByParams(params);
		if (ls2.size() > 0) {
			for (int k = 0; k < ls2.size(); k++) {
				je2 += ls2.get(k).getJe();
				se2 += ls2.get(k).getSe();
				jshj2 += ls2.get(k).getJshj();
			}
		}
		try {
			String[] headers = { "日期", "正常开具金额", "正常开具税额", "正常开具价税合计", "正常开具发票数量", "红冲开具金额", "红冲开具税额", "红冲开具价税合计",
					"红冲开具发票数量", "发票换开金额", "发票换开税额", "发票换开价税合计", "发票换开发票数量" };
			// 第一步，创建一个webbook，对应一个Excel文件
			HSSFWorkbook wb = new HSSFWorkbook();
			// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
			HSSFSheet sheet = wb.createSheet("已开发票");
			// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
			HSSFRow row = sheet.createRow(0);
			// 第四步，创建单元格，并设置值表头 设置表头居中
			HSSFCellStyle style = wb.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			HSSFCell cell = null;
			for (int i = 0; i < headers.length; i++) {
				cell = row.createCell(i);
				cell.setCellValue(headers[i]);
				cell.setCellStyle(style);
			}
			row = sheet.createRow(1);
			row.createCell(0).setCellValue(kprq);
			row.createCell(1).setCellValue(je1);
			row.createCell(2).setCellValue(se1);
			row.createCell(3).setCellValue(jshj1);
			row.createCell(4).setCellValue(ls1.size());
			row.createCell(5).setCellValue(je2);
			row.createCell(6).setCellValue(se2);
			row.createCell(7).setCellValue(jshj2);
			row.createCell(8).setCellValue(ls2.size());
			row.createCell(9).setCellValue(je3);
			row.createCell(10).setCellValue(se3);
			row.createCell(11).setCellValue(jshj3);
			row.createCell(12).setCellValue(ls3.size());
			SimpleDateFormat timeFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String filename = timeFormat.format(new Date()) + ".xls";
			response.setContentType("application/vnd.ms-excel;charset=UTF-8");
			response.setHeader("Content-Disposition",
					"attachment;filename=".concat(String.valueOf(URLEncoder.encode(filename, "UTF-8"))));
			OutputStream out = response.getOutputStream();
			wb.write(out);
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
