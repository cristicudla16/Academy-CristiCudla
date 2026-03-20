public with sharing class WeatherResponseWrapper {
    
    // Aceasta este clasa pe care o caută testul tău (WeatherResponseWrapper.WeatherResponse)
    public class WeatherResponse {
        @AuraEnabled public Coord coord;
        @AuraEnabled public List<Weather> weather;
        @AuraEnabled public Main main;
        @AuraEnabled public Wind wind;
        @AuraEnabled public Clouds clouds;
        @AuraEnabled public Sys sys;
        @AuraEnabled public String base;
        @AuraEnabled public Integer visibility;
        @AuraEnabled public Integer dt;
        @AuraEnabled public Integer timezone;
        @AuraEnabled public Long id;
        @AuraEnabled public String name;
        @AuraEnabled public Integer cod;
    }

    public class Coord {
        @AuraEnabled public Double lat;
        @AuraEnabled public Double lon;
    }
    public class Weather {
        @AuraEnabled public Integer id;
        @AuraEnabled public String main;
        @AuraEnabled public String description;
        @AuraEnabled public String icon;
    }
    public class Main {
        @AuraEnabled public Double temp;
        @AuraEnabled public Double feels_like;
        @AuraEnabled public Double temp_min;
        @AuraEnabled public Double temp_max;
        @AuraEnabled public Integer pressure;
        @AuraEnabled public Integer humidity;
        @AuraEnabled public Integer sea_level;
        @AuraEnabled public Integer grnd_level;
    }
    public class Wind {
        @AuraEnabled public Double speed;
        @AuraEnabled public Integer deg;
    }
    public class Clouds {
        @AuraEnabled public Integer all;
    }
    public class Sys {
        @AuraEnabled public Integer type;
        @AuraEnabled public Long id;
        @AuraEnabled public String country;
        @AuraEnabled public Integer sunrise;
        @AuraEnabled public Integer sunset;
    }

    public static WeatherResponse parse(String json) {
        return (WeatherResponse) System.JSON.deserialize(json, WeatherResponse.class);
    }
}