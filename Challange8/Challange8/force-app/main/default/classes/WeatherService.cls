public with sharing class WeatherService {
    // Excepția custom folosită pentru a raporta erorile către LWC
    public class WeatherServiceException extends Exception {}

    @AuraEnabled(cacheable=true)
    public static WeatherResponseWrapper.WeatherResponse getWeatherData(String cityName) {
        // Validare de bază pentru numele orașului
        if (String.isBlank(cityName)) {
            throw new WeatherServiceException('City name cannot be blank.');
        }

        // Cheia ta API validă
        String apiKey = '370aac9671471bb68ddb9c5cabf535c9'; 
        
        // Construirea URL-ului cu unități metrice pentru Celsius
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + 
                          EncodingUtil.urlEncode(cityName, 'UTF-8') + 
                          '&appid=' + apiKey + '&units=metric';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                // Returnează obiectul WeatherResponse către componenta LWC
                return WeatherResponseWrapper.parse(response.getBody());
            } else {
                // Aruncă excepția cu mesajul exact pe care testul Jest îl caută
                throw new WeatherServiceException('Failed to retrieve weather data: City not found');
            }
        } catch (Exception e) {
            // Re-aruncă eroarea pentru a fi prinsă de blocul catch din JavaScript
            throw new WeatherServiceException(e.getMessage());
        }
    }
}