const lanIP = `${window.location.hostname}:5000`;
//const socket = io(`http://${lanIP}`);
//const backend_IP = 'http://127.0.0.1:5000';

let lastTemp = 0;
let lastHum = 0;
let lastLight = 0;
let lastCM = 0;

let temperatureGraph = null;
let tempChart = null;
let humidityGraph = null;
let humChart = null;
let lightGraph = null;
let lightChart = null;
let cmGraph = null;
let cmChart = null;

/*const listenToSocket = function () {
  socket.on("connected", function () {
    console.info("verbonden met socket webserver");
  });

  socket.on("TEMP", function(jsonObject) {
    console.log(jsonObject);
  });

  socket.on("HUM", function(jsonObject) {
    console.log(jsonObject);
  });
};*/

const generateTemperatureGraph = function(json) {
  console.log("Generating Temperature Graph");
  //console.log(json);
  let data = getAPIData(json);
  let labels = getAPILabels(json);
  lastTemp = data[0];
  console.log(lastTemp);
  temperatureGraph = document.querySelector(".js-temp").getContext('2d');
  tempChart = new Chart(temperatureGraph, {
    // The type of chart we want to create
    type: 'line',
    // The data for our dataset
    data: {
        labels: labels,
        label: `Time`,
        borderWidth: 1,
        datasets: [{
            label: `Temperature in Celcius`,
            backgroundColor: 'rgb(0,152,121)',
            borderColor: 'rgb(0, 177, 141)',
            data: data,
            fill: false
        }]
    },

    // Configuration options go here
    options: {
    }
  });
};

const generateHumidityGraph = function(json) {
  console.log("Generating Humidity Graph");
  //console.log(json);
  let data = getAPIData(json);
  let labels = getAPILabels(json);
  lastHum = data[0];
  console.log(parseInt(lastHum));
  humidityGraph = document.querySelector(".js-hum").getContext('2d');
  humChart = new Chart(humidityGraph, {
    // The type of chart we want to create
    type: 'line',
    // The data for our dataset
    data: {
        labels: labels,
        label: `Humidity`,
        borderWidth: 1,
        datasets: [{
            label: `% Of Humidity`,
            backgroundColor: 'rgb(0,152,121)',
            borderColor: 'rgb(0, 177, 141)',
            data: data,
            fill: false
        }]
    },

    // Configuration options go here
    options: {
    }
  });
};

const generateLightGraph = function(json) {
  console.log("Generating Light Graph");
  //console.log(json);
  let data = getAPIData(json);
  let labels = getAPILabels(json);
  lastLight = data[0];
  console.log(lastLight);
  lightGraph = document.querySelector(".js-light").getContext('2d');
  lightChart = new Chart(lightGraph, {
    // The type of chart we want to create
    type: 'line',
    // The data for our dataset
    data: {
        labels: labels,
        label: `Light`,
        borderWidth: 1,
        datasets: [{
            label: `Lux`,
            backgroundColor: 'rgb(0,152,121)',
            borderColor: 'rgb(0, 177, 141)',
            data: data,
            fill: false
        }]
    },

    // Configuration options go here
    options: {
    }
  });
};

const generateCMGraph = function(json) {
  console.log("Generating CM Graph");
  //console.log(json);
  let data = getAPIData(json);
  let labels = getAPILabels(json);
  lastCM = data[0];
  console.log(lastCM);
  cmGraph = document.querySelector(".js-cm").getContext('2d');
  cmChart = new Chart(cmGraph, {
    // The type of chart we want to create
    type: 'bar',
    // The data for our dataset
    data: {
        labels: labels,
        label: `CM`,
        borderWidth: 1,
        datasets: [{
            label: `Particles Per Square Meter`,
            backgroundColor: 'rgb(0,152,121)',
            borderColor: 'rgb(0, 177, 141)',
            data: data,
            fill: false
        }]
    },

    // Configuration options go here
    options: {
    }
  });
};

const getAPILabels = function(json) {
  console.log("Getting Labels!");
  let result = [];
  for(const entry of json) {
      if(entry["DateTaken"] != null) {
          result.push(entry["DateTaken"].substr(5, 7) + entry["DateTaken"].substr(17, 5));
      } 
  }
  return result;
};

const getAPIData = function(json) {
  console.log("Getting Data!");
  let result = [];
  for(const entry of json) {
      if(entry["Waarde"] != null) {
          //result.push((entry["value"]).toLocaleString('be-BE'));
          result.push(entry["Waarde"]);
      }
  }
  return result;
};

const updateGraphTitle = function() {
  //Air Quality < 200 is safe
  //Humidity [30,60]%
  //Perfect temperatuur [20, 25]
  //light >500
  let gastitle = document.querySelector(".js-title-gas");
  if(parseInt(lastCM) > 200) { gastitle.classList.add("c-graphhead-neg"); }
  else { gastitle.classList.remove("c-graphhead-neg"); }

  let humtitle = document.querySelector(".js-title-hum");
  if((parseInt(lastHum) < 30 || parseInt(lastHum) > 60)) { humtitle.classList.add("c-graphhead-neg"); } 
  else { humtitle.classList.remove("c-graphhead-neg"); }

  let temptitle = document.querySelector(".js-title-temp");
  if((parseInt(lastTemp) < 20 || parseInt(lastTemp) > 24)) { temptitle.classList.add("c-graphhead-neg"); } 
  else { temptitle.classList.remove("c-graphhead-neg"); }

  let lighttitle = document.querySelector(".js-title-light");
  if(parseInt(lastLight) < 500) { lighttitle.classList.add("c-graphhead-neg"); } 
  else { lighttitle.classList.remove("c-graphhead-neg"); }
};

document.addEventListener("DOMContentLoaded", function () {
  console.info("DOM geladen");
  //listenToSocket();
  handleData(`http://${lanIP}/api/v1/temperature/10`, generateTemperatureGraph);
  handleData(`http://${lanIP}/api/v1/humidity/10`, generateHumidityGraph);
  handleData(`http://${lanIP}/api/v1/light/10`, generateLightGraph);
  handleData(`http://${lanIP}/api/v1/gas/10`, generateCMGraph);
  updateGraphTitle()
  
  setInterval(() => {
    tempChart.destroy();
    humChart.destroy();
    lightChart.destroy();
    cmChart.destroy();
    handleData(`http://${lanIP}/api/v1/temperature/10`, generateTemperatureGraph);
    handleData(`http://${lanIP}/api/v1/humidity/10`, generateHumidityGraph);
    handleData(`http://${lanIP}/api/v1/light/10`, generateLightGraph);
    handleData(`http://${lanIP}/api/v1/gas/10`, generateCMGraph);
    console.log("Updating the graphs");
    updateGraphTitle()
  }, 120000)
});
