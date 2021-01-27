$(document).ready(function () {


    /* Graphique Statistiques*/



function TimeUpdate(DateArr,DateDep,cbk){

    //Envoyer les dates côtés serveur ->get

    $.post('/getChart',{DateArr:DateArr,DateDep:DateDep},function(data){
            console.log(data);
            cbk(data)
            return data;
    //    utiliser l'occupation par parking de cette plage

    },'json');
}

    $("input[name='trip-start']").change(function(){
    // récup 2 dates :
        let DateArr = $("#start").val();
        let DateDep = $("#end").val();
        console.log(DateArr);
        TimeUpdate(DateArr,DateDep, displayStats);
//TODO : mettre à jour le graphe

    });    //installer timeupdate sur les 2 widgets

var myChart;
function displayStats(donnees)
    {
        let labelsC = donnees.map(function (e)
        {
            return "Parking" + e.x
        });

        let dataC = donnees.map(function (e)
        {
            return (e.y)
        });

        if (myChart != undefined || myChart !=null) {
            myChart.destroy();
        }


        var ctx = document.getElementById('myChart').getContext('2d');
        myChart = new Chart(ctx, {
            type: 'polarArea',
            data: {
                labels: labelsC, //dataC.label (x)
                datasets: [{
                    label: "Taux d'occupation des parkings",
                    data: dataC, //dataC.data (y)
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(155,29,32,0.2)',
                        'rgba(114,220,96,0.2)',
                        'rgba(99,93,92,0.2)',
                        'rgba(208,255,206,0.2)',
                        'rgba(252,43,255,0.2)',
                        'rgba(0,150,0,0.2)',
                        'rgba(0,0,0,0.2)',
                        'rgba(114,0,96,0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(155,29,32,1)',
                        'rgba(114,220,96,1)',
                        'rgba(99,93,92,1)',
                        'rgba(208,255,206,1)',
                        'rgba(252,43,255,1)',
                        'rgba(0,150,0,1)',
                        'rgba(0,0,0,1)',
                        'rgba(114,0,96,1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
}
        let DateArr = $("#start").val();
        let DateDep = $("#end").val();
TimeUpdate(DateArr, DateDep, displayStats);
});
