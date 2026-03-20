@isTest
private class WeatherServiceTest {
  @IsTest
  static void testGetWeatherDataSuccess() {
    // Define the mock HTTP response for a successful request
    String mockResponse = '{"coord":{"lon":-122.42,"lat":37.77},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":288.55,"feels_like":287.15,"temp_min":288.15,"temp_max":289.15,"pressure":1012,"humidity":82},"visibility":10000,"wind":{"speed":1.5,"deg":350},"clouds":{"all":1},"dt":1587234567,"sys":{"type":1,"id":5122,"country":"US","sunrise":1587204567,"sunset":1587250987},"timezone":-25200,"id":5391959,"name":"San Francisco","cod":200}';

    // Set the mock for the HTTP callout
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(mockResponse, 200)
    );

    Test.startTest();
    // Call the method to be tested
    WeatherResponseWrapper.WeatherResponse result = WeatherService.getWeatherData(
      'San Francisco'
    );
    Test.stopTest();

    // Validate the result
    System.assertNotEquals(null, result, 'The result should not be null');

    // Validate individual parameters in the response
    System.assertNotEquals(
      null,
      result.main,
      'The "main" field should not be null'
    );
    System.assertEquals(
      288.55,
      result.main.temp,
      'The temperature should match the mock response'
    );

    System.assertNotEquals(
      null,
      result.weather,
      'The "weather" list should not be null'
    );
    System.assertEquals(
      'clear sky',
      result.weather[0].description,
      'The weather description should match the mock response'
    );

    System.assertNotEquals(
      null,
      result.wind,
      'The "wind" field should not be null'
    );
    System.assertEquals(
      1.5,
      result.wind.speed,
      'The wind speed should match the mock response'
    );
  }

  @IsTest
  static void testGetWeatherDataFailure() {
    // Define the mock HTTP response for a failed request
    String mockResponse = '{"cod":"404","message":"city not found"}';

    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(mockResponse, 404)
    );

    Test.startTest();
    // Verify that the exception is thrown for a failed request
    try {
      WeatherResponseWrapper.WeatherResponse result = WeatherService.getWeatherData(
        'InvalidCity'
      );
      System.assert(false, 'A WeatherServiceException should have been thrown');
    } catch (WeatherService.WeatherServiceException e) {
      System.assertEquals(
        'Failed to retrieve weather data for city: InvalidCity',
        e.getMessage(),
        'The error message should match the expected exception message'
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void testWeatherResponseWrapperClasses() {
    // Instantiate the main `WeatherResponse` class
    WeatherResponseWrapper.WeatherResponse response = new WeatherResponseWrapper.WeatherResponse();

    // Set `Coord`
    response.coord = new WeatherResponseWrapper.Coord();
    response.coord.lat = 37.77;
    response.coord.lon = -122.42;

    // Set `Weather`
    response.weather = new List<WeatherResponseWrapper.Weather>();
    WeatherResponseWrapper.Weather weatherItem = new WeatherResponseWrapper.Weather();
    weatherItem.id = 800;
    weatherItem.main = 'Clear';
    weatherItem.description = 'clear sky';
    weatherItem.icon = '01d';
    response.weather.add(weatherItem);

    // Set `Main`
    response.main = new WeatherResponseWrapper.Main();
    response.main.temp = 288.55;
    response.main.feels_like = 287.15;
    response.main.temp_min = 288.15;
    response.main.temp_max = 289.15;
    response.main.pressure = 1012;
    response.main.humidity = 82;
    response.main.sea_level = 1019;
    response.main.grnd_level = 1016;

    // Set `Wind`
    response.wind = new WeatherResponseWrapper.Wind();
    response.wind.speed = 1.5;
    response.wind.deg = 350;

    // Set `Clouds`
    response.clouds = new WeatherResponseWrapper.Clouds();
    response.clouds.all = 1;

    // Set `Sys`
    response.sys = new WeatherResponseWrapper.Sys();
    response.sys.type = 1;
    response.sys.id = 5122;
    response.sys.country = 'US';
    response.sys.sunrise = 1587204567;
    response.sys.sunset = 1587250987;

    // Set other fields
    response.base = 'stations';
    response.visibility = 10000;
    response.dt = 1587234567;
    response.timezone = -25200;
    response.id = 5391959;
    response.name = 'San Francisco';
    response.cod = 200;

    // Validate the properties to ensure the values are correct
    System.assertEquals(37.77, response.coord.lat, 'Latitude should be 37.77');
    System.assertEquals(
      -122.42,
      response.coord.lon,
      'Longitude should be -122.42'
    );
    System.assertEquals(
      800,
      response.weather[0].id,
      'Weather ID should be 800'
    );
    System.assertEquals(
      'Clear',
      response.weather[0].main,
      'Weather main should be "Clear"'
    );
    System.assertEquals(
      'clear sky',
      response.weather[0].description,
      'Weather description should be "clear sky"'
    );
    System.assertEquals(
      '01d',
      response.weather[0].icon,
      'Weather icon should be "01d"'
    );
    System.assertEquals(
      288.55,
      response.main.temp,
      'Temperature should be 288.55'
    );
    System.assertEquals(
      287.15,
      response.main.feels_like,
      'Feels like temperature should be 287.15'
    );
    System.assertEquals(
      288.15,
      response.main.temp_min,
      'Minimum temperature should be 288.15'
    );
    System.assertEquals(
      289.15,
      response.main.temp_max,
      'Maximum temperature should be 289.15'
    );
    System.assertEquals(
      1012,
      response.main.pressure,
      'Pressure should be 1012'
    );
    System.assertEquals(82, response.main.humidity, 'Humidity should be 82');
    System.assertEquals(
      1019,
      response.main.sea_level,
      'Sea level pressure should be 1019'
    );
    System.assertEquals(
      1016,
      response.main.grnd_level,
      'Ground level pressure should be 1016'
    );
    System.assertEquals(1.5, response.wind.speed, 'Wind speed should be 1.5');
    System.assertEquals(350, response.wind.deg, 'Wind degree should be 350');
    System.assertEquals(1, response.clouds.all, 'Cloudiness should be 1');
    System.assertEquals(
      1587234567,
      response.dt,
      'Datetime should be 1587234567'
    );
    System.assertEquals(1, response.sys.type, 'Sys type should be 1');
    System.assertEquals(5122, response.sys.id, 'Sys ID should be 5122');
    System.assertEquals('US', response.sys.country, 'Country should be "US"');
    System.assertEquals(
      1587204567,
      response.sys.sunrise,
      'Sunrise should be 1587204567'
    );
    System.assertEquals(
      1587250987,
      response.sys.sunset,
      'Sunset should be 1587250987'
    );
    System.assertEquals(-25200, response.timezone, 'Timezone should be -25200');
    System.assertEquals(5391959, response.id, 'City ID should be 5391959');
    System.assertEquals(
      'San Francisco',
      response.name,
      'City name should be "San Francisco"'
    );
    System.assertEquals(200, response.cod, 'COD should be 200');
  }
}
