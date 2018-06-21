public class CreatingWizardController {

	public Flight__c newFlight { get; set; }
	public Addon__c newAddon { get; set; }
	public Price__c newPriceToFlight { get; set; }
	public Price__c newPriceToAddon { get; set; }

	public CreatingWizardController() {
		this.newFlight = new Flight__c();
		this.newAddon = new Addon__c();
		this.newPriceToFlight = new Price__c();
		this.newPriceToAddon = new Price__c(); 
	}
	
	public PageReference step1() {
		return Page.CreatingWizardStep1;
	}

	public PageReference step2() {
		return Page.CreatingWizardStep2;
	}

	public void saveFlight() {

		ApexPages.getMessages().clear();

		if (newFlight.Number__c != null && newFlight.CityFrom__c != null && newFlight.CityTo__c != null &&
			newFlight.FlightCompany__c != null && newFlight.TimeOfFlight__c != null && 
			newFlight.TotalNumberOfSeats__c != null && newFlight.Type__c != null) {
			insert newFlight;
		} else {
			ApexPages.addMessage(
				new ApexPages.Message(
				ApexPages.Severity.ERROR,
                'Fill all fields, please!'));
            return;
		}

		if (newPriceToFlight.Value__c != null && newPriceToFlight.DateFrom__c != null && 
			newPriceToFlight.DateTo__c != null) {
			newPriceToFlight.Flight__c = newFlight.Id;
			insert newPriceToFlight;
		}

		newFlight = new Flight__c();
		newPriceToFlight = new Price__c();

	}

	public void saveAddon() {

		ApexPages.getMessages().clear();

		if (newAddon.RecordType.Name != null && newAddon.Name != null) {
			if (newAddon.RecordType.Name != 'Eating' || newAddon.RecordType.Name != 'Plaid' ||
				newAddon.RecordType.Name != 'Pillow') {
				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.Severity.ERROR,
						'Invalid RecordType!'));
				return;
			}
			insert newAddon;
		} else {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.ERROR,
                	'Fill all fields, please!'));
            return;
		}

		if (newPriceToFlight.Value__c != null && newPriceToFlight.DateFrom__c != null && 
			newPriceToFlight.DateTo__c != null) {
			newPriceToAddon.Addon__c = newAddon.Id;
			insert newPriceToAddon;
		}

		newAddon = new Addon__c();
		newPriceToAddon = new Price__c();
		
	}

}