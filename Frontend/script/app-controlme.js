const lanIP = `${window.location.hostname}:5000`;

let sendbutton;
let resetbutton;
let colorpicker;

const hextorgb = function(json) {
    console.log(json);
}

const displaymessage = function(json) {
    console.log(json);
}

document.addEventListener("DOMContentLoaded", function () {
    console.info("DOM geladen");
    sendbutton = document.querySelector('.js-send');
    resetbutton = document.querySelector('.js-reset');
    colorpicker = document.querySelector('.js-colorpicker');

    sendbutton.addEventListener('click', function() {
        //console.log(`${colorpicker.value}`);
        var aRgbHex = `${colorpicker.value.substr(1)}`.match(/.{1,2}/g);
        var aRgb = [
            parseInt(aRgbHex[0], 16),
            parseInt(aRgbHex[1], 16),
            parseInt(aRgbHex[2], 16)
        ];
        console.log(`http://${lanIP}/api/v1/leds/${parseInt(aRgbHex[0], 16)}/${parseInt(aRgbHex[1], 16)}/${parseInt(aRgbHex[2], 16)}`); //[21, 2, 190]
        handleData(`http://${lanIP}/api/v1/leds/${parseInt(aRgbHex[0], 16)}/${parseInt(aRgbHex[1], 16)}/${parseInt(aRgbHex[2], 16)}`, displaymessage);
    });

    resetbutton.addEventListener('click', function() {
        handleData(`http://${lanIP}/api/v1/leds/reset`, displaymessage);
    });
});