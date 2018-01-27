package com.rjxx.taxeasy.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.dingtalk.oapi.lib.aes.DingTalkEncryptException;
import com.dingtalk.oapi.lib.aes.DingTalkEncryptor;
import com.rjxx.taxeasy.dingding.Model.event.SuiteCallBackMessage;
import com.rjxx.taxeasy.dingding.suite.SuitePushType;
import com.rjxx.taxeasy.domains.IsvSuite;
import com.rjxx.taxeasy.domains.IsvSuiteTicket;
import com.rjxx.taxeasy.service.IsvCorpSuiteAuthService;
import com.rjxx.taxeasy.service.IsvSuiteService;
import com.rjxx.taxeasy.service.IsvSuiteTicketService;
import com.rjxx.taxeasy.web.BaseController;
@Controller
@RequestMapping("/suiteCallBackController")
public class SuiteCallBackController extends BaseController{
private Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    private IsvSuiteService isvSuiteService;
    
    @Autowired
    private IsvSuiteTicketService isvsuiteticketservice;
    
    @Autowired
    private IsvCorpSuiteAuthService isvcorpsuiteauthservice;
    
    
    
    @RequestMapping
    public String index() {
        return "index";
    }
    @ResponseBody
    @RequestMapping(value = "/suite/create", method = {RequestMethod.POST})
    public Map<String, String> suiteCreate(@RequestParam(value = "signature", required = false) String signature,
                                           @RequestParam(value = "timestamp", required = false) String timestamp,
                                           @RequestParam(value = "nonce", required = false) String nonce,
                                           @RequestBody(required = false) JSONObject json){
        /**
         * token,aseKey这两个参数在注册套件的时候,填写的。如果不想改代码,那么注册套件的时候也可以填写下面的两个数值
         * 要注意信息安全哦.
         */
        logger.info("====套件创建回调开始==== signature:{}, timestamp:{}, nonce:{}，json:{}",
                signature, timestamp, nonce,json);
        try {
            String token = "rjxx";
            String aseKey = "f818mnnjcsp269yct2vmaseb1eamq6ytmhuq5wcx042";
            DingTalkEncryptor dingTalkEncryptor = new DingTalkEncryptor(token, aseKey, "suite0o5v9vws5ffxsthr");
            String encryptMsg = json.getString("encrypt");
            String plainText = dingTalkEncryptor.getDecryptMsg(signature, timestamp, nonce, encryptMsg);
            JSONObject callbackMsgJson = JSONObject.parseObject(plainText);
            String random = callbackMsgJson.getString("Random");
            String responseEncryMsg = random;
            Map<String, String> encryptedMap = dingTalkEncryptor.getEncryptedMap(responseEncryMsg, System.currentTimeMillis(), com.dingtalk.oapi.lib.aes.Utils.getRandomStr(8));
            return encryptedMap;
        } catch (DingTalkEncryptException e) {
            e.printStackTrace();
            logger.info("====套件创建回调失败==== signature:{}, timestamp:{}, nonce:{}，json:{}",
                    signature, timestamp, nonce,json);
            return null;
        }
    }
    /**
     * 当套件创建完毕之后,需要手动修改一下套件的回调地址。在修改套件的回调地址之前,需要在BD中插入一条记录
     *
     *  insert into isv_suite(id, gmt_create, gmt_modified, suite_name, suite_key, suite_secret, encoding_aes_key, token, event_receive_url)
     *  values(1, '2016-03-14 18:08:09', '2016-03-14 18:08:09', '服务报警应用', 'suitexdhgv7mnxxxxxxxx', 'xxxxxxxxxxKBJLLPtmFmwRtKfsuiEHHpBPx8jGlCSp-iznz9gFSpkG0T0KMU9jyB',
     *  'dd18qxxxxxx357g8r7itm5pyu5hg8ibe1blhqawhuaz', 'xxxxqaz2WSX', '');
     *
     * @param suiteKey
     * @param signature
     * @param timestamp
     * @param nonce
     * @param json
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/suite/callback/{suiteKey}", method = {RequestMethod.POST})
    public  Map<String, String> receiveCallBack(@PathVariable("suiteKey") String suiteKey,
                                                @RequestParam(value = "signature", required = false) String signature,
                                                @RequestParam(value = "timestamp", required = false) String timestamp,
                                                @RequestParam(value = "nonce", required = false) String nonce,
                                                @RequestBody(required = false) JSONObject json
    ) {
        
        try {
        	Map map=new HashMap();
            map.put("suiteKey",suiteKey);
            IsvSuite isvSuite=isvSuiteService.getIsvSuite(map);
			DingTalkEncryptor dingTalkEncryptor = new DingTalkEncryptor(isvSuite.getToken(), isvSuite.getEncodingAesKey(), isvSuite.getSuiteKey());
			String encryptMsg = json.getString("encrypt");
	        String plainText = dingTalkEncryptor.getDecryptMsg(signature,timestamp,nonce,encryptMsg);
	        
	        logger.info("====解密之后明文消息==== suiteKey:{},signature:{}, timestamp:{}, nonce:{}，json:{},plainText:{}",
	        		suiteKey,signature, timestamp, nonce,json,plainText);
	      //具体业务处理
            String returnStr = isvCallbackEvent(plainText,suiteKey) ;
            Map<String, String> encryptedMap = dingTalkEncryptor.getEncryptedMap(returnStr, System.currentTimeMillis(), com.dingtalk.oapi.lib.aes.Utils.getRandomStr(8));
            return encryptedMap;
        } catch (DingTalkEncryptException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.info("====解密失败程序异常==== suiteKey:{},signature:{}, timestamp:{}, nonce:{}，json:{}",
	        		suiteKey,signature, timestamp, nonce,json);
			return null;
		}
       
    }
    /**
     * 处理各种回调时间的TAG。这个维度的回调是和套件相关的
     * 根据不同的返回码处理对应的业务
     * @param callbackMsg
     * @param suiteKey
     * @return
     */
    private String isvCallbackEvent(String callbackMsg,String suiteKey) {
    	 JSONObject callbackMsgJson = JSONObject.parseObject(callbackMsg);
         String eventType = callbackMsgJson.getString("EventType");
         String responseEncryMsg = "success";
         if(SuitePushType.SUITE_TICKET.getKey().equals(eventType)){
        	 String receiveSuiteTicket = callbackMsgJson.getString("SuiteTicket");
             String receiveSuiteKey = callbackMsgJson.getString("SuiteKey");
             Map params=new HashMap();
             params.put("SuiteKey", suiteKey);
             IsvSuiteTicket isvsuiteticket1=isvsuiteticketservice.findOneByParams(params);
        	 IsvSuiteTicket isvsuiteticket=new IsvSuiteTicket();
        	 isvsuiteticket.setTicket(receiveSuiteTicket);
        	 isvsuiteticket.setSuiteKey(suiteKey);
        	 isvsuiteticket.setId(isvsuiteticket1.getId());
        	 
        	 //保存或者更新套件的SuiteTicket，有过期时间
        	 boolean sr=isvsuiteticketservice.saveOrUpdateSuiteTicket(isvsuiteticket);
        	 if(!sr){
        		 responseEncryMsg = "faile";
        	 }
        	 
         }else if(SuitePushType.TMP_AUTH_CODE.getKey().equals(eventType)){
        	 //获取企业永久授权码
        	 String tmpAuthCode = callbackMsgJson.getString("AuthCode");
        	 boolean sr=isvcorpsuiteauthservice.saveOrUpdateCorpSuiteAuth(suiteKey, tmpAuthCode);
             if(!sr){
            	 responseEncryMsg = "faile";
             }
         }else if(SuitePushType.CHANGE_AUTH.getKey().equals(eventType)){
             String corpId = callbackMsgJson.getString("AuthCorpId");
             boolean  sr = isvcorpsuiteauthservice.handleChangeAuth(suiteKey,corpId);
             if(!sr){
                 responseEncryMsg = "faile";
             }
         }else if(SuitePushType.SUITE_RELIEVE.getKey().equals(eventType)){
             String receiveCorpId = callbackMsgJson.getString("AuthCorpId");
             boolean  sr = isvcorpsuiteauthservice.handleRelieveAuth(suiteKey,receiveCorpId);
             if(!sr){
                 responseEncryMsg = "faile";
             }
         }else if(SuitePushType.CHECK_CREATE_SUITE_URL.getKey().equals(eventType)){
             //TODO
         }else if(SuitePushType.CHECK_UPDATE_SUITE_URL.getKey().equals(eventType)){
             String random = callbackMsgJson.getString("Random");
             responseEncryMsg = random;
         }else if(SuitePushType.CHECK_SUITE_LICENSE_CODE.getKey().equals(eventType)){
             //TODO
             //留给业务自行判断
        }else{
            //当开放平台更新了新的推送类型,为了避免不认识,需要报警出来
            logger.info("====无法识别的EventType==== suiteKey:{},callbackMsg:{}",
	        		suiteKey,callbackMsg);
        }
         return responseEncryMsg;
    }
    /**
     * 企业接受接受回调事件。这个维度的回调都是和授权企业相关的
     * @param suiteKey
     * @param signature
     * @param timestamp
     * @param nonce
     * @param json
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/suite/corp_callback/{suiteKey}", method = {RequestMethod.POST})
    public Map<String, String>  corpSuiteCallBack(@PathVariable("suiteKey") String suiteKey,
                                                @RequestParam(value = "signature", required = false) String signature,
                                                @RequestParam(value = "timestamp", required = false) String timestamp,
                                                @RequestParam(value = "nonce", required = false) String nonce,
                                                @RequestBody(required = false) JSONObject json
    ) {
    	try{
	    	Map map=new HashMap();
	        map.put("suiteKey",suiteKey);
	        IsvSuite isvSuite=isvSuiteService.getIsvSuite(map);
	        DingTalkEncryptor dingTalkEncryptor = new DingTalkEncryptor(isvSuite.getToken(), isvSuite.getEncodingAesKey(), isvSuite.getSuiteKey());
	        String encryptMsg = json.getString("encrypt");
            String plainText = dingTalkEncryptor.getDecryptMsg(signature, timestamp, nonce, encryptMsg);
            logger.info("====解密之后明文消息==== suiteKey:{},signature:{}, timestamp:{}, nonce:{}，json:{},plainText:{}",
	        		suiteKey,signature, timestamp, nonce,json,plainText);
            JSONObject jsonObject = JSON.parseObject(plainText);
            String eventType = jsonObject.getString("EventType");
            if("check_url".equals(eventType)){
                Map<String, String> encryptedMap = dingTalkEncryptor.getEncryptedMap("success", System.currentTimeMillis(), com.dingtalk.oapi.lib.aes.Utils.getRandomStr(8));
                return encryptedMap;
            }
          //处理不同的回调事件,如果不关心的就不用处理
            SuiteCallBackMessage.Tag tag = null;
            if(SuiteCallBackMessage.Tag.USER_ADD_ORG.getKey().equals(eventType)){
                tag =  SuiteCallBackMessage.Tag.USER_ADD_ORG;
            }else if(SuiteCallBackMessage.Tag.USER_LEAVE_ORG.getKey().equals(eventType)){
                tag =  SuiteCallBackMessage.Tag.USER_LEAVE_ORG;
            }else if(SuiteCallBackMessage.Tag.CRM_CUSTOMER_UPDATE.getKey().equals(eventType)){
                tag =  SuiteCallBackMessage.Tag.CRM_CUSTOMER_UPDATE;
            }else if(SuiteCallBackMessage.Tag.CRM_CONTACT_CALL.getKey().equals(eventType)){
                tag =  SuiteCallBackMessage.Tag.CRM_CONTACT_CALL;
            }else if(SuiteCallBackMessage.Tag.REPORT_ADD_CRM_REPORT.getKey().equals(eventType)){
                tag =  SuiteCallBackMessage.Tag.REPORT_ADD_CRM_REPORT;
            }
            if(null!=tag){
                //通知业务方各种回调事件,业务方实现各自的业务
                //多加入一个套件Key维度
                jsonObject.put("suiteKey",suiteKey);
               // jmsTemplate.send(suiteCallBackQueue,new SuiteCallBackMessage(jsonObject,tag));
            }
            Map<String, String> encryptedMap = dingTalkEncryptor.getEncryptedMap("success", System.currentTimeMillis(), com.dingtalk.oapi.lib.aes.Utils.getRandomStr(8));
            return encryptedMap;
    	}catch(Exception e){
    		logger.info(" suiteKey:{},signature:{}, timestamp:{}, nonce:{}，json:{}",
	        		suiteKey,signature, timestamp, nonce,json);
    		return null;
    	}
    }
}
