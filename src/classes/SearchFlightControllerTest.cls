@isTest
private class SearchFlightControllerTest {

	@isTest static void testGetQuerySelectAddons() {
		
		String Food = 'testFood';
		String Plaid = 'testPlaid';
		String Pillow = 'testPillow';

		Test.startTest();

		PageReference pageRef = Page.SearchAndBookingFlight;
		Test.setCurrentPage(pageRef);

		SearchFlightController sfController = new SearchFlightController();

		// without addons
		sfController.setFood('');
		sfController.setPlaid('');
		sfController.setPillow('');
		String querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with all addons
		sfController.setFood(Food);
		sfController.setPlaid(Plaid);
		sfController.setPillow(Pillow);
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' (Addon__r.Name = :Food OR Addon__r.Name = :Plaid OR Addon__r.Name = :Pillow ) AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with food addon
		sfController.setFood(Food);
		sfController.setPlaid('');
		sfController.setPillow('');
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' Addon__r.Name = :Food AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with plaid addon
		sfController.setFood('');
		sfController.setPlaid(Plaid);
		sfController.setPillow('');
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' Addon__r.Name = :Plaid AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with pillow addon
		sfController.setFood('');
		sfController.setPlaid('');
		sfController.setPillow(Pillow);
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' Addon__r.Name = :Pillow AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with food and plaid addons
		sfController.setFood(Food);
		sfController.setPlaid(Plaid);
		sfController.setPillow('');
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' (Addon__r.Name = :Food OR Addon__r.Name = :Plaid) AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with food and pillow addons
		sfController.setFood(Food);
		sfController.setPlaid('');
		sfController.setPillow(Pillow);
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' (Addon__r.Name = :Food OR Addon__r.Name = :Pillow) AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		// with plaid and pillow addons
		sfController.setFood('');
		sfController.setPlaid(Plaid);
		sfController.setPillow(Pillow);
		querySelectAddons = sfController.getQuerySelectAddons();
		System.assertEquals(querySelectAddons, 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + ' (Addon__r.Name = :Plaid OR Addon__r.Name = :Pillow) AND ' +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) ) ' + 
            ' ORDER BY Value__c DESC ');

		Test.stopTest();

	}
	
	@isTest static void testDoSearch1() {
		
		String DateFrom = '2018-07-10';
		String DateTo = '2018-07-01';

		Test.startTest();

		PageReference pageRef = Page.SearchAndBookingFlight;
		Test.setCurrentPage(pageRef);

		SearchFlightController sfController = new SearchFlightController();

		sfController.setDateFrom(DateFrom);
		sfController.setDateTo(DateTo);

		sfController.doSearch();

		ApexPages.Message msg = ApexPages.getMessages()[0];
		String msgDetail = msg.getDetail();

		System.assertEquals(msgDetail, 'Date From can not be greater than Date To');

		Test.stopTest();

	}

	@isTest static void testDoSearch2() {
		
		String DateFrom = '2018-07-01';
		String DateTo = '2018-07-10';
		String CityFrom = 'testCityFrom';
		String CityTo = 'testCityTo';

		Test.startTest();

		PageReference pageRef = Page.SearchAndBookingFlight;
		Test.setCurrentPage(pageRef);

		SearchFlightController sfController = new SearchFlightController();

		sfController.setDateFrom(DateFrom);
		sfController.setDateTo(DateTo);
		sfController.setCityFrom(CityFrom);
		sfController.setCityTo(CityTo);

		sfController.doSearch();

		ApexPages.Message msg = ApexPages.getMessages()[0];
		String msgDetail = msg.getDetail();

		System.assertEquals(msgDetail, 'Flights were not found');

		Test.stopTest();

	}
	
	
}