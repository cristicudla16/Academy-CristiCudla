import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CITY_FIELD from '@salesforce/schema/Account.BillingCity';
import getWeatherData from '@salesforce/apex/WeatherService.getWeatherData';

export default class AccountWeather extends LightningElement {
    @api recordId;
    weatherData;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: [CITY_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            const city = getFieldValue(data, CITY_FIELD);
            if (city) {
                this.handleFetchWeather(city);
            } else {
                this.error = 'Failed to retrieve account city';
            }
        } else if (error) {
            this.error = 'Failed to retrieve account city';
        }
    }

    async handleFetchWeather(city) {
        try {
            const data = await getWeatherData({ cityName: city });
            if (data && data.main && data.weather && data.weather.length > 0) {
                this.weatherData = data;
                this.error = undefined;
            } else {
                this.error = 'Invalid weather data structure returned by the API.';
            }
        } catch (err) {
            this.error = 'Failed to retrieve weather data: ' + (err.body?.message || err.message);
            this.weatherData = undefined;
        }
    }

    get weatherDescription() {
        return this.weatherData?.weather[0]?.description;
    }

    get weatherTemp() {
        return this.weatherData?.main?.temp;
    }

    get iconUrl() {
        const icon = this.weatherData?.weather[0]?.icon;
        return icon ? `https://openweathermap.org/img/wn/${icon}@2x.png` : '';
    }
}