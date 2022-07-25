$(function () {
    window.addEventListener("message", function (event) {
        switch (event.data.action) {
            case "SetValues":
                setAnzahle(event.data.sp, event.data.pp);
                break;
            case "UI":
                switch (event.data.bool) {
                    case true:
                        $("#UI").show();
                        break;
                    case false:
                        $("#UI").hide();
                        break;
                    default:
                        console.error("non-specified argument received");
                }
                break;
            case "showLogo":
                $("#logo").show();
                break;
            case "ShowDetails":
                switch (event.data.type) {
                    case "normal":
                        $("#Aufzaehlungen2").show();
                        $("#Aufzaehlungen3").hide();
                        break;
                    case "premium":
                        $("#Aufzaehlungen3").show();
                        $("#Aufzaehlungen2").hide();
                        break;
                }
                break;
            default:
                console.error("non-specified message received");
                break;
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $("#UI").hide();
            $.post('http://sch_carwash/exit', JSON.stringify({}));
            return
        }
    };
});

function WashVehicle() {
    $.post('https://sch_carwash/WashVehicle', JSON.stringify({}));
}

function WashHalfVehicle() {
    $.post('https://sch_carwash/WashHalfVehicle', JSON.stringify({}));
}

function setAnzahle(sp, pp) {
    $("#preis").html(new Intl.NumberFormat('de-DE').format(sp) + "$");
    $("#preis2").html(new Intl.NumberFormat('de-DE').format(pp) + "$");
}