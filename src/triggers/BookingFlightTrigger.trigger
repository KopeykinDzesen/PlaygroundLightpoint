trigger BookingFlightTrigger on BookedFlight__c (before insert) {

	List<BookedFlight__c> bfList = Trigger.New;
	List<Id> flightIdList = new List<Id>();
	for (BookedFlight__c bf : bfList) {
		flightIdList.add(bf.Flight__c);
	}
	List<Flight__c> flightWithAttrList = [SELECT SeatAmount__c, isBooked__c FROM Flight__c WHERE Id IN :flightIdList];
	List<Flight__c> flights = new List<Flight__c>(); // Здесь будут хранится рейсы в соответствии bfList
	for (Id id : flightIdList) {
		for (Flight__c f : flightWithAttrList) {
			if (f.Id == id) {
				flights.add(f);
			}
		}
	}

	System.debug(bfList);	
	System.debug(flightIdList);
	System.debug(flightWithAttrList);					  

	for (Integer i = 0; i < flights.size(); i++) {
		if (flights[i].isBooked__c) {
			System.debug('all places are booked');
			bfList[i].AddError('all places are booked');			
		} else {
			flights[i].SeatAmount__c --;
			if (flights[i].SeatAmount__c == 0) {
				flights[i].isBooked__c = true;
			}
		}
	}

	update flights;






	//BookedFlight__c bf = Trigger.New[0];

	//Flight__c flight = [SELECT SeatAmount__c, isBooked__c FROM Flight__c WHERE Id = :bf.Flight__c];

	//System.debug(flight.isBooked__c);
	//System.debug(flight.SeatAmount__c);
	//if (flight.isBooked__c) {
	//	System.debug('all places are booked');
	//	bf.AddError('all places are booked');
	//} else {
	//	System.debug('flight.SeatAmount__c --;');
	//	flight.SeatAmount__c --;
	//	if (flight.SeatAmount__c == 0) {
	//		System.debug('flight.isBooked__c = true;');
	//		flight.isBooked__c = true;
	//	}
	//}

	//update flight;

}