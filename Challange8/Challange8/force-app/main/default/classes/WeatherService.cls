public with sharing class WeatherService {
    public class WeatherServiceException extends Exception {}

    @AuraEnabled(cacheable=true)
    public static WeatherResponseWrapper getWeatherData(String cityName) {
        // Aici pui logica de Http Callout (vezi exemplul meu anterior)
        // Daca response.getStatusCode() != 200:
        // throw new WeatherServiceException('Failed to retrieve weather data for city: ' + cityName);
        
        // Returneaza WeatherResponseWrapper.parse(response.getBody());
    }
}