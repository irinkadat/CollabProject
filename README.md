## Overview
UIKit-based iOS application featuring a tab bar with multiple pages. Each page integrates with different APIs to provide various information related to air quality, weather, species, solar resources, and population. Below are the details for each page and the APIs used.

## Pages

### 1. Air Quality Page
This page provides information on air quality for a specific city based on inputed coordinates. It also includes general information about air quality.

- **API Documentation:** [IQAir API](https://api-docs.iqair.com/?version=latest)
- **Example API Call:** http://api.airvisual.com/v2/nearest_city?lat=41.716667&lon=44.783333&key={API_KEY}
  
- **Features:**
- Input city coordinates latitude and longitude (e.g 37.7749, -122.4194; 41.716667, 44.783333)  to get specific city's air quality data.

### 2. Weather Page
This page provides weather forecasts based on specific latitude and longitude coordinates, which offers the possibility to find weather forecasts by coordinates of a specific city.

- **API Documentation:** [OpenWeatherMap 5 Day / 3 Hour Forecast API](https://openweathermap.org/forecast5)
- **Example API Call:** https://api.openweathermap.org/data/2.5/forecast?lat={LAT}&lon={LON}&appid={API_KEY}

- **Features:**
-  Input city name to retrieve weather data.

### 3. Species Page
This page allows users to enter a city name to find the latest species of animals and plants found in that city.

- **API Documentation:**
- [iNaturalist Autocomplete API](https://api.inaturalist.org/v1/places/autocomplete?q=CITY_NAME)
- [iNaturalist Species Counts API](https://api.inaturalist.org/v1/observations/species_counts?place_id=CITY_ID)
- **Example API Calls:**
- https://api.inaturalist.org/v1/places/autocomplete?q={CITY_NAME}
- https://api.inaturalist.org/v1/observations/species_counts?place_id={CITY_ID}

- **Features:**
- Display species images, names, uploader information, and Wikipedia links.

### 4. Solar Resource Page
This page provides solar resource data for a specific American address.

- **API Documentation:** [NREL Solar Resource API](https://developer.nrel.gov/docs/solar/solar-resource-v1/)
- **Example API Call:** 
- https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=\(apiKey)&lat=\(lat)&lon=\(lon)&attributes=avg_dni,avg_ghi,avg_tilt_at_latitude

- **Features:**
- Input two attributes: longitude and latitude and  output correscponding average Direct Normal Irradiance, Global Horizontal Irradiance, and Tilt at Latitude.
- API only supports american addresses 

### 5. Population Page
This page displays the population for a specified country for today and tomorrow.

- **API Documentation:** [Population.io API](https://d6wn6bmjj722w.population.io/)
- **Example API Call:** 
https://d6wn6bmjj722w.population.io/1.0/population/{COUNTRY}/today-and-tomorrow/

- **Features:**
- Input country name to get population data.
