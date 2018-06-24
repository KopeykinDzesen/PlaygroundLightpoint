trigger BookingFlightTrigger on BookedFlight__c (before insert) {

	List<Id> flightIdList = new List<Id>();
	for (BookedFlight__c bf : Trigger.New) {
		flightIdList.add(bf.Flight__c);
	}

	Map<Id, Flight__c> flightById = new Map<Id, Flight__c>(
		[SELECT RemainingNumberOfSeats__c FROM Flight__c WHERE Id IN :flightIdList]);

	System.debug(flightById);

	List<Flight__c> flightsToUpdate = new List<Flight__c>();
	for (BookedFlight__c bf : Trigger.New) {
		if (flightById.get(bf.Flight__c).RemainingNumberOfSeats__c <= 0) {
			System.debug('all places are booked');
			bf.AddError('All places ere booked!');
		} else {
			flightById.get(bf.Flight__c).RemainingNumberOfSeats__c --;
			System.debug(flightById.get(bf.Flight__c).RemainingNumberOfSeats__c);
		}
		flightsToUpdate.add(flightById.get(bf.Flight__c));
	}	
	System.debug(flightsToUpdate);		  

	update flightsToUpdate;




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