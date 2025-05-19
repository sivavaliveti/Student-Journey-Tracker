public with sharing class Sjtexample {
  
    @AuraEnabled(cacheable=false)
    public static String callSOAPAPI(String inputParam) {
        String soapEndpoint = 'https://www.dataaccess.com/webservicesserver/NumberConversion.wso';
        
        String requestBody = '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
            'xmlns:num="http://www.dataaccess.com/webservicesserver/">' +
            '<soapenv:Header/>' +
            '<soapenv:Body>' +
            '<num:NumberToWords>' + 
            '<num:ubiNum>' + inputParam + '</num:ubiNum>' +
            '</num:NumberToWords>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(soapEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '"NumberToWords"');
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                // Extract the meaningful response using XML parsing
                String responseBody = res.getBody();
                
                // Extract the value between <m:NumberToWordsResult> and </m:NumberToWordsResult>
                Pattern regex = Pattern.compile('<m:NumberToWordsResult>(.*?)</m:NumberToWordsResult>');
                Matcher matcher = regex.matcher(responseBody);
                
                if (matcher.find()) {
                    return matcher.group(1).trim(); // Return extracted text
                } else {
                    return 'Error: Could not parse response';
                }
            } else {
                return 'Error: ' + res.getStatus();
            }
        } catch (Exception e) {
            return 'Exception: ' + e.getMessage();
        }
    }
        }