$(document).ready(function () {


    /* Graphique Statistiques*/


    $.post('/getChart',{},function(donnees)
    {
        let labelsC = donnees.map(function (e)
        {
            alert(e.x)
            return "Parking" + e.x
        });

        let dataC = donnees.map(function (e)
        {
            alert((e.y))
            return (14-e.y)/14
        });

        let dataArr = donnees.map(function (e)
        {
            return (e.A)
        });


        let dataDep = donnees.map(function (e)
        {
            return (e.D)
        });




        var ctx = document.getElementById('myChart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'bar',
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
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
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
    },'json');

});
