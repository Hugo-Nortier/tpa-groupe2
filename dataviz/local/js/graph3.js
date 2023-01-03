google.charts.load('current', { packages: ['corechart', 'bar'] });
google.charts.setOnLoadCallback(draw2ndGraphe);


function draw2ndGraphe() {
    //get data
    let dataDB = marketing["data"]
    let profils = new Set()
    profils.add("Categorie")
    let categories = new Set()

    let vals = {}

    for (let i = 0; i < dataDB.length; i++) {
      if (dataDB[i][2] == 1 || dataDB[i][0]=="N/D") {
        dataDB.splice(i, 1)
        i--
      }
      else {
        profils.add(dataDB[i][0])
        categories.add(dataDB[i][1])
        vals[dataDB[i][0] + dataDB[i][1]] = dataDB[i][2]
      }
    }
    let firstline = Array.from(profils);
    let cataloguelist = Array.from(categories)
    let results = []
    results.push(firstline)
    for (let i = 0; i < cataloguelist.length; i++) {
      let res = []
      res.push(cataloguelist[i])
      for (let j = 1; j < firstline.length; j++) {
        res.push(vals[firstline[j] + cataloguelist[i]] || 0)
      }
      results.push(res)
    }
    var data = google.visualization.arrayToDataTable(results
    );

    var options = {
      title: 'Categories de voitures vendues en fonction de la situation familiale du client',
      chartArea: { width: '50%', },
      hAxis: {
        title: 'Total en nombre de ventes',
        minValue: 0,
        textStyle: {
          bold: true,
          fontSize: 12,
          color: '#4d4d4d'
        },
        titleTextStyle: {
          bold: true,
          fontSize: 18,
          color: '#4d4d4d'
        }
      },
      vAxis: {
        title: 'Categorie',
        textStyle: {
          fontSize: 14,
          bold: true,
          color: '#848484'
        },
        titleTextStyle: {
          fontSize: 14,
          bold: true,
          color: '#848484'
        }
      }
    };
    var chart = new google.visualization.BarChart(document.getElementById('chart_3'));
    chart.draw(data, options);

}