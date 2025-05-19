public with sharing class SjtexampleRest {
  
    @AuraEnabled(cacheable=false)
    public static String callRESTAPI(String inputParam) {
        String restEndpoint = 'https://api.math.tools/numbers/words?number=' + EncodingUtil.urlEncode(inputParam, 'UTF-8');

        HttpRequest req = new HttpRequest();
        req.setEndpoint(restEndpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);
            System.debug('API Response: ' + res.getBody()); // Debug API response

            if (res.getStatusCode() == 200) {
                // Deserialize response into a map
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                // Check if "contents" exists
                if (responseMap.containsKey('contents')) {
                    Map<String, Object> contents = (Map<String, Object>) responseMap.get('contents');

                    // Get 'result' or 'cardinal' field
                    if (contents.containsKey('result')) {
                        return String.valueOf(contents.get('result'));
                    } else if (contents.containsKey('cardinal')) {
                        return String.valueOf(contents.get('cardinal'));
                    }
                }
                return 'Error: Unexpected response format';
            } else {
                return 'Error: HTTP Status ' + res.getStatusCode();
            }
        } catch (Exception e) {
            return 'Exception: ' + e.getMessage();
        }
    }
}