anychart.onDocumentReady(function () {
    // set the data
    let Http = new XMLHttpRequest();
    let url = 'http://localhost:9001/api/energie';
    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = (e) => {
        let json = JSON.parse(Http.responseText)
        let data = json["data"]
        let dataGraph = [
            {
                x: "≤ 100 g/km", value: data[0], normal: {
                    fill: "#37944e",
                }
            },
            {
                x: "de 100 à 120 g/km", value: data[1], normal: {
                    fill: "#2ee02b",
                }
            },
            {
                x: "de 121 à 140 g/km", value: data[2], normal: {
                    fill: "#a7e02b",
                }
            },
            {
                x: "de 141 à 160 g/km", value: data[3], normal: {
                    fill: "#f5f52a",
                }
            },
            {
                x: "de 161 à 200 g/km", value: data[4], normal: {
                    fill: "#f5b820",
                }
            },
            {
                x: "de 201 à 250 g/km", value: data[5], normal: {
                    fill: "#f56e20",
                }
            },
            {
                x: "≥ 251 g/km", value: data[6], normal: {
                    fill: "#f52020",
                }
            }
        ];
        // create the chart
        var chart = anychart.pie();

        // set the chart title
        chart.title("Repartition des voitures en fonction de l'émission de CO2");
        // add the data
        chart.data(dataGraph);
        chart
            .labels()
            .position('outside')
            .offsetY(0)
            .enabled(true)
            .format('{%X}');

        chart.listen("pointClick", function (e) {
            var index = e.iterator.getIndex();
            console.log("afficher details des voitures presentes dont emission est " + data[index].x)

        });

        // sort elements
        //chart.sort("desc");  

        // set legend position
        chart.legend().position("right");
        // set items layout
        chart.legend().itemsLayout("vertical");

        // display the chart in the container
        document.getElementById('chart_4').innerHTML = "";
        chart.container('chart_4');
        chart.draw();

    }


});