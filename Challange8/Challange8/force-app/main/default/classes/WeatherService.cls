public with sharing class WeatherService {
    public class WeatherServiceException extends Exception {}

    @AuraEnabled(cacheable=true)
    public static WeatherResponseWrapper.WeatherResponse getWeatherData(String cityName) {
        if (String.isBlank(cityName)) {
            throw new WeatherServiceException('City name cannot be blank.');
        }

        String apiKey = 'YOUR_API_KEY'; // Pune cheia ta aici
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + 
                          EncodingUtil.urlEncode(cityName, 'UTF-8') + 
                          '&appid=' + apiKey + '&units=metric';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            // AICI era lipsa: trebuie returnat rezultatul parsării
            return WeatherResponseWrapper.parse(response.getBody());
        } else {
            throw new WeatherServiceException('Failed to retrieve weather data for city: ' + cityName);
        }
    }
}