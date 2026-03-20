// Import necessary modules and utilities
import { createElement } from "lwc";
import AccountWeather from "c/accountWeather";
import getWeatherData from "@salesforce/apex/WeatherService.getWeatherData";
import { getRecord } from "lightning/uiRecordApi";
import { registerTestWireAdapter } from "@salesforce/wire-service-jest-util";

// Mocking the Apex method
jest.mock(
  "@salesforce/apex/WeatherService.getWeatherData",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

// Register the wire adapter
const getRecordAdapter = registerTestWireAdapter(getRecord);

// Utility function to wait for all promises to resolve
function flushPromises() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

describe("c-account-weather", () => {
  afterEach(() => {
    // Clean up the DOM after each test case
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    // Clear any mock calls
    jest.clearAllMocks();
  });

  it("displays weather data correctly when Apex call is successful", async () => {
    // Mock the Apex call to return weather data
    getWeatherData.mockResolvedValue({
      main: { temp: 288.55 },
      weather: [{ description: "clear sky", icon: "01d" }]
    });

    // Create and attach the component to the DOM
    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "0011700000pJRRSAA4"; // Mock recordId
    document.body.appendChild(element);

    // Emit data from the getRecord wire adapter
    getRecordAdapter.emit({
      fields: {
        BillingCity: { value: "San Francisco" }
      }
    });

    // Wait for all async operations to finish
    await flushPromises();

    // Query all heading elements
    const headingElements = element.shadowRoot.querySelectorAll(
      "p.slds-text-heading_small"
    );

    // Initialize variables to hold the elements
    let descriptionElement = null;
    let temperatureElement = null;

    // Iterate over heading elements to find the ones we need
    headingElements.forEach((el) => {
      if (el.textContent.includes("Description")) {
        descriptionElement = el;
      } else if (el.textContent.includes("Temperature")) {
        temperatureElement = el;
      }
    });

    // Assert that the elements are found and have correct content
    expect(descriptionElement).not.toBeNull();
    expect(descriptionElement.textContent).toContain("Description clear sky");

    expect(temperatureElement).not.toBeNull();
    expect(temperatureElement.textContent).toContain("Temperature 288.55");

    // Query for the icon element
    const iconElement = element.shadowRoot.querySelector("img");

    expect(iconElement).not.toBeNull();
    expect(iconElement.src).toContain(
      "https://openweathermap.org/img/wn/01d@2x.png"
    );
  });

  it("shows error message when getWeatherData Apex call fails", async () => {
    // Mock the Apex call to reject the promise
    getWeatherData.mockRejectedValue({
      body: { message: "City not found" }
    });

    // Create and attach the component to the DOM
    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "0011700000pJRRSAA4"; // Mock recordId
    document.body.appendChild(element);

    // Emit data from the getRecord wire adapter
    getRecordAdapter.emit({
      fields: {
        BillingCity: { value: "InvalidCity" }
      }
    });

    // Wait for all async operations to finish
    await flushPromises();

    // Query the DOM for the error message
    const errorElement = element.shadowRoot.querySelector(
      ".slds-text-color_error"
    );

    // Assert that the error message is displayed correctly
    expect(errorElement).not.toBeNull();
    expect(errorElement.textContent).toContain(
      "Failed to retrieve weather data: City not found"
    );
  });

  it("displays account city retrieval error when getRecord fails", async () => {
    // Create and attach the component to the DOM
    const element = createElement("c-account-weather", {
      is: AccountWeather
    });
    element.recordId = "0011700000pJRRSAA4"; // Mock recordId
    document.body.appendChild(element);

    // Simulate an error from the getRecord wire adapter
    getRecordAdapter.error(new Error("Record retrieval error"));

    // Wait for all async operations to finish
    await flushPromises();

    // Query the DOM for the error message
    const errorElement = element.shadowRoot.querySelector(
      ".slds-text-color_error"
    );

    // Assert that the error message is displayed correctly
    expect(errorElement).not.toBeNull();
    expect(errorElement.textContent).toContain(
      "Failed to retrieve account city"
    );
  });
});

it("displays error message for invalid weather data structure", async () => {
  // Mock the Apex call to return an invalid weather data structure
  getWeatherData.mockResolvedValue({
    main: undefined, // Invalid structure (missing main field)
    weather: [] // Empty weather array
  });

  // Create and attach the component to the DOM
  const element = createElement("c-account-weather", {
    is: AccountWeather
  });
  element.recordId = "0011700000pJRRSAA4"; // Mock recordId
  document.body.appendChild(element);

  // Emit data from the getRecord wire adapter
  getRecordAdapter.emit({
    fields: {
      BillingCity: { value: "San Francisco" }
    }
  });

  // Wait for all async operations to finish
  await flushPromises();

  // Query the DOM for the error message
  const errorElement = element.shadowRoot.querySelector(
    ".slds-text-color_error"
  );

  // Assert that the error message is displayed correctly
  expect(errorElement).not.toBeNull();
  expect(errorElement.textContent).toContain(
    "Invalid weather data structure returned by the API."
  );
});

it("displays detailed error message when getWeatherData call fails with error.body", async () => {
  // Mock the Apex call to reject the promise with an error object that has `body` and `body.message`
  getWeatherData.mockRejectedValue({
    body: { message: "Mocked error message from body" }
  });

  // Create and attach the component to the DOM
  const element = createElement("c-account-weather", {
    is: AccountWeather
  });
  element.recordId = "0011700000pJRRSAA4"; // Mock recordId
  document.body.appendChild(element);

  // Emit data from the getRecord wire adapter
  getRecordAdapter.emit({
    fields: {
      BillingCity: { value: "San Francisco" }
    }
  });

  // Wait for all async operations to finish
  await flushPromises();

  // Query the DOM for the error message
  const errorElement = element.shadowRoot.querySelector(
    ".slds-text-color_error"
  );

  // Assert that the error message is displayed correctly
  expect(errorElement).not.toBeNull();
  expect(errorElement.textContent).toBe(
    "Failed to retrieve weather data: Mocked error message from body"
  );
});
