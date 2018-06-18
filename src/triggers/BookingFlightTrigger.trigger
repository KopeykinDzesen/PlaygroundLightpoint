trigger BookingFlightTrigger on BookedFlight__c (before insert) {

	BookedFlight__c bf = Trigger.New[0];

	Flight__c flight = [SELECT SeatAmount__c, isBooked__c FROM Flight__c WHERE Id = :bf.Flight__c];

	System.debug(flight.isBooked__c);
	System.debug(flight.SeatAmount__c);
	if (flight.isBooked__c) {
		System.debug('all places are booked');
		bf.AddError('all places are booked');
	} else {
		System.debug('flight.SeatAmount__c --;');
		flight.SeatAmount__c --;
		if (flight.SeatAmount__c == 0) {
			System.debug('flight.isBooked__c = true;');
			flight.isBooked__c = true;
		}
	}

	update flight;

}