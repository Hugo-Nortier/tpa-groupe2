anychart.onDocumentReady(function () {

    let dataviz = []
    dataviz.push({ name: "Immatriculations", children: [] })
    let tree = {}
    let dataDB = modelesCount["data"]
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


});