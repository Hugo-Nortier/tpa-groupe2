anychart.onDocumentReady(function () {

    let Http = new XMLHttpRequest();
    let url = 'http://localhost:9001/api/categories/count';
    Http.open("GET", url);
    Http.send();
    let maxid = 0

    Http.onreadystatechange = (e) => {
        let dataviz = []
        let previds = {}

        let json = JSON.parse(Http.responseText)
        let dataDB = json["data"]
        for (let i = 0; i < dataDB.length; i++) {
            if (dataDB[i][0] != "categorie") {
                if (previds[dataDB[i][0]] == undefined) {
                    dataviz.push(
                        {
                            "id": i,
                            "name": dataDB[i][0],
                            "value": dataDB[i][1]
                        },
                    )
                    previds[dataDB[i][0]] = i
                    maxid++
                }

            }
        }
        let Http2 = new XMLHttpRequest();
        let url2 = 'http://localhost:9001/api/marques/count';
        Http2.open("GET", url2);
        Http2.send();

        Http2.onreadystatechange = (e) => {
            let json2 = JSON.parse(Http2.responseText)
            let dataDB2 = json2["data"]
            for (let j = 0; j < dataDB2.length; j++) {
                if (dataDB2[j][0] != "categorie") {
                    if (previds[dataDB2[j][0]+dataDB2[j][1]] == undefined) {
                        dataviz.push(
                            {
                                "id": j + maxid,
                                "name": dataDB2[j][1],
                                "value": dataDB2[j][2],
                                "parent": previds[dataDB2[j][0]]
                            },
                        )
                        previds[dataDB2[j][0] + dataDB2[j][1]] = (j+maxid)
                        maxid++
                    }
                }
            }
            
            let Http3 = new XMLHttpRequest();
            let url3 = 'http://localhost:9001/api/modeles/count';
            Http3.open("GET", url3);
            Http3.send();
            Http3.onreadystatechange = (e) => {
                let json3 = JSON.parse(Http3.responseText)
                let dataDB3 = json3["data"]
                for (let z = 0; z < dataDB3.length; z++) {
                    if (dataDB3[z][0] != "categorie") {
                        if (previds[dataDB3[z][0]+dataDB3[z][1]+dataDB3[z][2]] == undefined) {
                            dataviz.push(
                                {
                                    "id": z + maxid,
                                    "name": dataDB3[z][2],
                                    "value": dataDB3[z][3],
                                    "parent": previds[dataDB3[z][0]+dataDB3[z][1]]
                                },
                            )
                            previds[dataDB3[z][0]+dataDB3[z][1]+dataDB3[z][2]] = (z+maxid)
                            maxid++
                        }
                    }
                }
    
                // add data
                var treeData = anychart.data.tree(dataviz, 'as-table');
    
                // create a circle packing chart instance
                var chart = anychart.circlePacking(treeData);
    
                // add a chart title
                chart.title("Vente totale de voitures (Circle Packing)")
                document.getElementById('chart_1').innerHTML = "";
                chart.container('chart_1');
                chart.draw();
            }
        }
    }
});