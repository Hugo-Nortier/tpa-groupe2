anychart.onDocumentReady(function () {
    let Http = new XMLHttpRequest();
    let url = 'http://localhost:9001/api/modeles/count';
    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = (e) => {
        let dataviz = []
        dataviz.push({ name: "Immatriculations", children: [] })
        let tree = {}
        let json = JSON.parse(Http.responseText)
        let dataDB = json["data"]
        for (let i = 0; i < dataDB.length; i++) {
            if (dataDB[i][0] != "categorie") {
                if (tree[dataDB[i][0]] == undefined) {
                    tree[dataDB[i][0]] = { name: dataDB[i][0], children: {} }
                }
                let children = tree[dataDB[i][0]].children
                if (children[dataDB[i][1]] == undefined) {
                    children[dataDB[i][1]] = { name: dataDB[i][1], children: [] }
                }
                let finaln = children[dataDB[i][1]].children
                finaln.push({ name: dataDB[i][2], value: dataDB[i][3] })
            }
        }

        Object.keys(tree).forEach((value) => {
            let children = []
            Object.keys(tree[value].children).forEach((child) => children.push(tree[value].children[child]));
            tree[value].children = children
            dataviz[0].children.push(tree[value])
        });
        // create a chart and set the data
        var chart = anychart.treeMap(dataviz, "as-tree");

        // set the maximum depth of levels shown
        chart.maxDepth(2);

        // set the depth of hints
        chart.hintDepth(1);

        // set the opacity of hints
        chart.hintOpacity(0.7);

        // configure labels
        chart.labels().format("{%name}");

        // disable tooltips
        chart.tooltip(false);

        // set the chart title
        chart.title("Vente totale de voitures (Treemap)");

        // set the container id
        document.getElementById('chart_2').innerHTML = "";
        chart.container("chart_2");


        // initiate drawing the chart
        chart.draw();

        // create and configure a color scale.
        var customColorScale = anychart.scales.ordinalColor();
        customColorScale.ranges([
            { less: 20000 },
            { from: 20001, to: 50000 },
            { from: 50001, to: 100000 },
            { from: 100001, to: 150000 },
            { from: 150001, to: 200000 },
            { from: 200001, to: 250000 },
            { greater: 250000 }
        ]);

        // set the color scale as the color scale of the chart
        chart.colorScale(customColorScale);

        // add a color range
        chart.colorRange().enabled(true);
        chart.colorRange().length("90%");


    }
});

/*
// create data
var data = [
    {
        name: "Catalogue", children: [
            {
                name: "Sportive", children: [
                    {
                        name: "Item 1-1", children: [
                            { name: "Item 1-1-1", value: 1000 },
                            { name: "Item 1-1-2", value: 600 },
                            { name: "Item 1-1-3", value: 550 },
                            { name: "Item 1-1-4", value: 300 },
                            { name: "Item 1-1-5", value: 150 }
                        ]
                    },
                    { name: "Item 1-2", value: 2300 },
                    { name: "Item 1-3", value: 1500 }
                ]
            },
            {
                name: "Compacte", children: [
                    {
                        name: "Item 2-1", children: [
                            { name: "Item 2-1-1", value: 2100 },
                            { name: "Item 2-1-2", value: 1000 },
                            { name: "Item 2-1-3", value: 800 },
                            { name: "Item 2-1-4", value: 750 }
                        ]
                    },
                    {
                        name: "Item 2-2", children: [
                            { name: "Item 2-2-1", value: 560 },
                            { name: "Item 2-2-2", value: 300 },
                            { name: "Item 2-2-3", value: 150 },
                            { name: "Item 2-2-4", value: 90 }
                        ]
                    },
                    { name: "Item 2-3", value: 400 }
                ]
            },
            {
                name: "Berline", children: [
                    {
                        name: "Item 3-1", children: [
                            { name: "Item 3-1-1", value: 850 },
                            { name: "Item 3-1-2", value: 400 },
                            { name: "Item 3-1-3", value: 150 }
                        ]
                    },
                    { name: "Item 3-2", value: 1350 },
                    { name: "Item 3-3", value: 1300 },
                    {
                        name: "Item 3-4", children: [
                            { name: "Item 3-4-1", value: 400 },
                            { name: "Item 3-4-2", value: 300 },
                            { name: "Item 3-4-3", value: 250 },
                            { name: "Item 3-4-4", value: 150 }
                        ]
                    }
                ]
            },
            {
                name: "SUV", children: [
                    {
                        name: "Item 4-1", children: [
                            { name: "Item 4-1-1", value: 100 },
                            { name: "Item 4-1-2", value: 200 },
                            { name: "Item 4-1-3", value: 150 }
                        ]
                    },
                ]
            }
        ]
    }
];
return data;
*/