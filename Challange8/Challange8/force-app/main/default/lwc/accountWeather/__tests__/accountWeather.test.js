// Importă modulele necesare
import { createElement } from "lwc";
import AccountWeather from "c/accountWeather"; // Numele trebuie să fie accountWeather
import getWeatherData from "@salesforce/apex/WeatherService.getWeatherData";
import { getRecord } from "lightning/uiRecordApi";
import { registerTestWireAdapter } from "@salesforce/wire-service-jest-util";

// Mocking pentru metoda Apex
jest.mock(
  "@salesforce/apex/WeatherService.getWeatherData",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

// Înregistrarea adaptorului de wire pentru getRecord
const getRecordAdapter = registerTestWireAdapter(getRecord);

// Funcție utilitară pentru a aștepta rezolvarea promisiunilor
function flushPromises() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

describe("c-account-weather", () => {
  afterEach(() => {
    // Curățarea DOM-ului după fiecare test
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  it("displays weather data correctly when Apex call is successful", async () => {
    // Simulează un răspuns de succes de la Apex
    getWeatherData.mockResolvedValue({
      main: { temp: 288.55 },
      weather: [{ description: "clear sky", icon: "01d" }]
    });

    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "0011700000pJRRSAA4";
    document.body.appendChild(element);

    // Trimite date către adaptorul de wire (orașul San Francisco)
    getRecordAdapter.emit({
      fields: {
        BillingCity: { value: "San Francisco" }
      }
    });

    await flushPromises();

    // Verifică dacă Description și Temperature apar în HTML
    const headingElements = element.shadowRoot.querySelectorAll("p.slds-text-heading_small");
    
    let descriptionText = "";
    let temperatureText = "";
    headingElements.forEach(el => {
        if(el.textContent.includes("Description")) descriptionText = el.textContent;
        if(el.textContent.includes("Temperature")) temperatureText = el.textContent;
    });

    expect(descriptionText).toContain("Description clear sky");
    expect(temperatureText).toContain("Temperature 288.55");

    const iconElement = element.shadowRoot.querySelector("img");
    expect(iconElement.src).toContain("https://openweathermap.org/img/wn/01d@2x.png");
  });

  it("shows error message when getWeatherData Apex call fails", async () => {
    // Simulează o eroare de la Apex
    getWeatherData.mockRejectedValue({
      body: { message: "City not found" }
    });

    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "0011700000pJRRSAA4";
    document.body.appendChild(element);

    getRecordAdapter.emit({
      fields: {
        BillingCity: { value: "InvalidCity" }
      }
    });

    await flushPromises();

    const errorElement = element.shadowRoot.querySelector(".slds-text-color_error");
    expect(errorElement.textContent).toContain("Failed to retrieve weather data: City not found");
  });

  it("displays account city retrieval error when getRecord fails", async () => {
    const element = createElement("c-account-weather", {
        is: AccountWeather
    });
    document.body.appendChild(element);

    // Simulează eșecul preluării datelor despre Account
    getRecordAdapter.error(new Error("Record retrieval error"));

    await flushPromises();

    const errorElement = element.shadowRoot.querySelector(".slds-text-color_error");
    expect(errorElement.textContent).toContain("Failed to retrieve account city");
  });
});