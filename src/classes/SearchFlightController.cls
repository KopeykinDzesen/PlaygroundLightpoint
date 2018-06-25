public class SearchFlightController {

    public String CityFrom { get; set; }
    public String CityTo { get; set; }
    public String DateFrom;
    public String getDateFrom() {
        return this.DateFrom;
    }
    public void setDateFrom(String s) {
        this.DateFrom = s;
    }
    public String DateTo;
     public String getDateTo() {
        return this.DateTo;
    }
    public void setDateTo(String s) {
        this.DateTo = s;
    }
    public String Food { get; set; }
    public String Plaid { get; set; }
    public String Pillow { get; set; }

    public String allPrices { get; set; }

    private List<Price__c> pricesFlightsList;
    private List<Price__c> pricesAddonsList;

    public String flightBook { get; set; }
    public String addonsBook { get; set; }
    public String bookedFlight { get; set; }

    public BookedFlight__c newBookedFlight { get; set; }

    public List<Integer> testStr { get; set; }

    public SearchFlightController() {
        this.CityFrom = '';
        this.CityTo = '';
        this.DateFrom = '';
        this.DateTo = '';
        this.Food = '';
        this.Plaid = '';
        this.Pillow = '';
        this.allPrices = '';
        this.pricesFlightsList = new List<Price__c>();
        this.pricesAddonsList = new List<Price__c>();
        this.flightBook = '';
        this.addonsBook = '';
        this.bookedFlight = '';
        this.newBookedFlight = new BookedFlight__c();

        this.testStr = new List<Integer>();
    }

    public void doSearch() {

        allPrices = '';
        pricesFlightsList = new List<Price__c>();
        pricesAddonsList = new List<Price__c>();
        Map<String, List<Price__c>> allPricesMap = new Map<String, List<Price__c>>();

        ApexPages.getMessages().clear();

        Date DDateFrom = Date.valueOf(DateFrom);
        Date DDateTo = Date.valueOf(DateTo);

        if (DDateFrom > DDateTo) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Date From can not be greater than Date To'));
            return;
        }

        String querySelectFlights = 'SELECT Value__c, Flight__r.Number__c,  Flight__r.CityFrom__c, Flight__r.CityTo__c, ' + 
            ' Flight__r.TimeOfFlight__c, Flight__r.Type__c, Flight__r.RemainingNumberOfSeats__c' + 
            ' FROM Price__c ' + 
            ' WHERE Flight__r.CityFrom__c = :CityFrom ' +   
            ' AND Flight__r.CityTo__c = :CityTo ' +
            ' AND ( ' + 
            ' NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) )' + 
            ' ORDER BY Value__c DESC ';

        pricesFlightsList = (List<Price__c>)Database.query(querySelectFlights);

        if (pricesFlightsList.size() == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Flights were not found')
                );
            return;
        }

        String condition = '';
        if (Food != '') {
            if (Plaid != '') {
                if (Pillow != '') {
                    condition = ' (Addon__r.Name = :Food OR Addon__r.Name = :Plaid OR Addon__r.Name = :Pillow ) AND ';
                } else {
                    condition = ' (Addon__r.Name = :Food OR Addon__r.Name = :Plaid) AND ';
                }
            } else if (Pillow != '') {
                condition = ' (Addon__r.Name = :Food OR Addon__r.Name = :Pillow) AND ';
            } else {      
                condition = ' Addon__r.Name = :Food AND ';
            }
        } else if (Plaid != '') {
            if (Pillow != '') {
                condition = ' (Addon__r.Name = :Plaid OR Addon__r.Name = :Pillow) AND ';
            } else {
                condition = ' Addon__r.Name = :Plaid AND ';
            }
        } else if (Pillow != '') {
            condition = ' Addon__r.Name = :Pillow AND ';
        }

        String querySelectAddons = 'SELECT Value__c, Addon__r.Name ' +
            ' FROM Price__c ' +
            ' WHERE ' + condition +
            ' ( NOT ( (DateFrom__c >= :DDateTo) ' +
            ' OR    (DateTo__c <= :DDateFrom) ) )' + 
            ' ORDER BY Value__c DESC ';

        pricesAddonsList = (List<Price__c>)Database.query(querySelectAddons);
        
        allPricesMap = new Map<String, List<Price__c>>{'Flights' => pricesFlightsList, 'Addons' => pricesAddonsList};
        allPrices = JSON.serialize(allPricesMap);

    }

    public void doBooking() {

        Decimal totalPrice = 0;
        Flight__c flight = new Flight__c();
        List<Addon__c> addons = new List<Addon__c>();

        if (flightBook == '') {
            Price__c expensiveFlight = pricesFlightsList[0];
            for (Integer i = 0; i < pricesFlightsList.size(); i++) {
                if (pricesFlightsList[i].Value__c > expensiveFlight.Value__c) {
                    expensiveFlight = pricesFlightsList[i];
                }
            }
            flight = expensiveFlight.Flight__r;
            totalPrice += expensiveFlight.Value__c;
        } else {           
            Integer flightNumber = (Integer)System.JSON.deserialize(flightBook, Integer.class);
            flight = pricesFlightsList[flightNumber].Flight__r;
            totalPrice += pricesFlightsList[flightNumber].Value__c;
        }
        
        if (addonsBook != '') {
            List<Integer> addonsNumbers = (List<Integer>)System.JSON.deserialize(addonsBook, List<Integer>.class);
            for (Integer i = 0; i < addonsNumbers.size(); i++) {
                addons.add(pricesAddonsList[addonsNumbers[i]].Addon__r);
                totalPrice += pricesAddonsList[addonsNumbers[i]].Value__c;
            }
        }

        newBookedFlight = new BookedFlight__c(BookingDate__c = System.today(),
                                                              TotalPrice__c = totalPrice,
                                                              Flight__c = flight.Id);

        insert newBookedFlight;

        List<BfAndAddonAssignment__c> bfAndAddonList = new List<BfAndAddonAssignment__c>();

        for (Addon__c ad : addons) {
            bfAndAddonList.add(new BfAndAddonAssignment__c(BookedFlight__c = newBookedFlight.Id, Addon__c = ad.Id));
        }

        insert bfAndAddonList;

    }

}