@RestResource(urlMapping='/book_flight')
global with sharing class GetFlightsResource  {

    @HttpPost
    global static String doPost() {

        RestRequest request = RestContext.request;
        Map<String, Object> resultMap = new Map<String, Object>();
        String resultStr = '';

        Map<String, Object> param = new Map<String, Object>();
        try {
            param = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        } catch (Exception ex) {
            resultMap.put('message', ex.getTypeName() + ' :: ' + ex.getMessage());
            resultMap.put('status', 'ERROR');
            resultStr = JSON.serialize(resultMap);
            return resultStr;
        }

        Date dateFrom = Date.valueOf(param.get('dateFrom').toString());
        Date dateTo = Date.valueOf(param.get('dateTo').toString());

        List<Price__c> listOfPrices = [SELECT Flight__c, Value__c FROM Price__c 
            WHERE NOT(DateFrom__c >= :dateTo OR DateTo__c <= :dateFrom) ORDER BY Value__c DESC LIMIT 1000];

        List<Id> listIdOfFlights = new List<Id>();
        for (Price__c p : listOfPrices) {
            listIdOfFlights.add(p.Flight__c);
        }

        Map<Id, Flight__c> mapOfFlights = new Map<Id, Flight__c>([SELECT TimeOfFlight__c, RemainingNumberOfSeats__c, 
            Number__c FROM Flight__c WHERE Id IN :listIdOfFlights]);

        for (Price__c pr : listOfPrices) {

            Flight__c f = mapOfFlights.get(pr.Flight__c);
            if (mapOfFlights.get(pr.Flight__c).RemainingNumberOfSeats__c == 0) {
                continue;
            }

            Date dateOfFlight = Date.newInstance(
                f.TimeOfFlight__c.year(), f.TimeOfFlight__c.month(), f.TimeOfFlight__c.day());
            if (dateOfFlight < dateFrom || dateOfFlight > dateTo) {
                continue;
            }

            BookedFlight__c bookedFlight = new BookedFlight__c(BookingDate__c = Date.today(),
                                                               Flight__c = f.Id,
                                                               TotalPrice__c = pr.Value__c);
            insert bookedFlight;

            resultMap.put('number', f.Number__c);
            resultMap.put('date', dateOfFlight);
            resultMap.put('price', pr.Value__c);
            resultMap.put('status', 'ACCESS');
            resultMap.put('message', 'Flight booked accessfully!');
            resultStr = JSON.serialize(resultMap);

            return resultStr;
        }

        return resultStr;

    }

}