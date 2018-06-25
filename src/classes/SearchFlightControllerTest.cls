@isTest
private class SearchFlightControllerTest {
	
	@isTest static void testDoSearch() {
		
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
	
	
}