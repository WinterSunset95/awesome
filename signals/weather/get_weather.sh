#!/bin/bash

weather_data=$(curl --request GET --url 'https://weatherapi-com.p.rapidapi.com/current.json?q=new%20delhi' --header 'x-rapidapi-host: weatherapi-com.p.rapidapi.com' --header 'x-rapidapi-key: b0286087bfmshfa69e2cad96216ep15190cjsn57eb91b3cf1b')

echo "$weather_data"
