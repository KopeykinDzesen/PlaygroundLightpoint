@isTest
private class TestBookingFlightTrigger {
	
	@isTest static void TestInsertSingleBookedFlight1() {

		Test.startTest();

		FlightCompany__c flightCompany = new FlightCompany__c(Name = 'com');
		insert flightCompany;

		Flight__c flight = new Flight__c(CityFrom__c = 'test1', CityTo__c = 'test2', Number__c = 100100,
				FlightCompany__c = flightCompany.Id, RemainingNumberOfSeats__c = 10, TotalNumberOfSeats__c = 10,
				TimeOfFlight__c = (Datetime)Date.today(), Type__c = 'Economy');
		insert flight;

		BookedFlight__c bf = new BookedFlight__c(TotalPrice__c = 200, Flight__c = flight.Id);
		insert bf;

		Flight__c testFlight = [SELECT RemainingNumberOfSeats__c FROM Flight__c WHERE Id = :flight.Id];

		System.assertEquals(9, testFlight.RemainingNumberOfSeats__c);

		Test.stopTest();
		
	}

	@isTest static void TestInsertSingleBookedFlight2() {

		Test.startTest();

		FlightCompany__c flightCompany = new FlightCompany__c(Name = 'com');
		insert flightCompany;

		Flight__c flight = new Flight__c(CityFrom__c = 'test1', CityTo__c = 'test2', Number__c = 100100,
				FlightCompany__c = flightCompany.Id, RemainingNumberOfSeats__c = 0, TotalNumberOfSeats__c = 10,
				TimeOfFlight__c = (Datetime)Date.today(), Type__c = 'Economy');
		insert flight;

		BookedFlight__c bf = new BookedFlight__c(TotalPrice__c = 200, Flight__c = flight.Id);
		Database.SaveResult result = Database.insert(bf, false);

		Flight__c testFlight = [SELECT RemainingNumberOfSeats__c FROM Flight__c WHERE Id = :flight.Id];

		System.assertEquals(0, testFlight.RemainingNumberOfSeats__c);
		System.assertEquals('All places ere booked!', result.getErrors()[0].getMessage());

		Test.stopTest();
		
	}
	
}



//@isTest
//private class TestRestrictContactByName {
	
//	@isTest static void TestInsertOrUpdateContactByName() {
		
//		Contact c = new Contact(LastName = 'INVALIDNAME');

//		//Test.startTest();
//		Database.SaveResult result = Database.insert(c, false);
//		//Test.stopTest();
		
//		System.assert(!result.isSuccess());
//        System.assert(result.getErrors().size() > 0);
//        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
//                             result.getErrors()[0].getMessage());

//	}
	
//}