<template>
    <lightning-card title="Account Weather" icon-name="utility:world">
        <div class="slds-p-around_medium">
            <template lwc:if={weatherData}>
                <div class="slds-grid slds-grid_vertical-align-center">
                    <img src={iconUrl} alt="Weather Icon" />
                    <div class="slds-m-left_medium">
                        <p class="slds-text-heading_small">Description {weatherDescription}</p>
                        <p class="slds-text-heading_small">Temperature {weatherTemp}</p>
                    </div>
                </div>
            </template>

            <template lwc:else if:true={error}>
                <p class="slds-text-color_error">{error}</p>
            </template>
        </div>
    </lightning-card>
</template>