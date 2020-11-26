## News Script Configuration Variables
NEWS_API_KEY="API_KEY_HERE"
NEWS_ENDPOINT="http://newsapi.org/v2/everything?sources=cbs-news&pageSize=3&apiKey=${NEWS_API_KEY}"
TITLE_WIDTH=65
LINE_WIDTH=65

## Weather Script Configuration Variables
WEATHER_API_KEY="API_KEY_HERE"
ZIP_CODE="89117"
WEATHER_ENDPOINT="https://api.openweathermap.org/data/2.5/weather?appid=${WEATHER_API_KEY}&zip=${ZIP_CODE},us&units=imperial"