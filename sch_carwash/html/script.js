$(function () {
    window.addEventListener("message", function (event) {
        if (event.data.action == "setStandard") {
            setAnzahl(event.data.pr)
            $("#preis").show();
        };
        if (event.data.action == "setPremium") {
            setAnzahle(event.data.pr)
            $("#preis2").show();
        };
        if (event.data.action == "showUI") {
            $("#UI").show();
        };
        if (event.data.action == "hideUI") {
            $("#UI").hide();
        };
        if (event.data.action == "showLogo") {
            $("#logo").show();
        };
        if (event.data.action == "hideLogo") {
            $("#logo").hide();
        };
        if (event.data.action == "showNormal") {
            $("#Aufzaehlungen2").show();
            $("#Aufzaehlungen3").hide();
        };
        if (event.data.action == "showPremium") {
            $("#Aufzaehlungen3").show();
            $("#Aufzaehlungen2").hide();
        };
    });
});

function display(bool) {
    if (bool) {
        $("#UI").show();
    } else {
        $("#UI").hide();
    }
    $.post('http://sch_carwash/exit', JSON.stringify({}));
            return
}

function WashVehicle() {
        $.post('https://sch_carwash/WashVehicle', JSON.stringify({}));
}

function WashHalfVehicle() {
        $.post('https://sch_carwash/WashHalfVehicle', JSON.stringify({}));
}

$(function () {
    function display(bool) {
        if (bool) {
            $("#UI").show();
        } else {
            $("#UI").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://sch_carwash/exit', JSON.stringify({}));
            return
        }
    };
});

function setAnzahl(anzahl) {
    document.getElementById("preis").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl) + "$";
}

function setAnzahle(anzahl) {
    document.getElementById("preis2").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl) + "$";
}