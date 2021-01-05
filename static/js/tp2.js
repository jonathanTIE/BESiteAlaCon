$(document).ready(function (){
$("button.btn-primary").on('click',function() {  change_nom(); });

    $("button.btn-secondary").on('click',function() { ligne_selectionnee(); });

    $("button.btn-info").on('click',function() { info_nom();  });

    $("button.btn-success").on('click',function() {  ajouter();  });

    $("button.btn-danger").on('click',function() {  supprimer(); });

    $("button.btn-warning").on('dblclick',function() { warning();   });

    $("button.btn-dark").on('click',function()  {  timeout();  });

});

/*######################################################################################*/
/* exercice 1 */

function change_nom()
{
    let td=$("table tr:nth-child(2)").children().eq(1); // on cherche le 2e enfant du 2e TR
    td.html("PARIS CDG");
}

/*######################################################################################*/
/* exercice 2 */

function ligne_selectionnee() {
    $("table tr:last").css('background-color','#cfdcec');
}


/*######################################################################################*/
/* exercice 3 */

function info_nom()
{
    change_nom();
    let msg="Le nom a été modifié";
    $("#message").html(msg).css('color','purple');
}


/*######################################################################################*/
/* exercice 4 */

function ajouter()
{
    let new_tr=" <tr>" +
        "        <th scope='row'>EGLL</th>" +
        "        <td>Heathrow Airport</td>" +
        "        <td>Grande-Bretagne</td>" +
        "        <td>51°28'16.3'N,  0°27'18.3'W </td>" +
        "    </tr>";

    $("table").append(new_tr);
}

/*######################################################################################*/
/* exercice 5 */

function supprimer()
{
    $("table tr:nth-child(2)").remove();
}

/*######################################################################################*/
/* exercice 6 */
/*function warning()
{
    alert('Prêt pour ajouter une ligne?');
    ajouter();
}*/

/*######################################################################################*/
/* exercice 6 - fenêtre modale */
function warning()
{
    //alert('Prêt pour ajouter une ligne?');
    $("#dialog").html('Prêt pour ajouter une ligne?');

    $( "#dialog" ).dialog({
        modal: true,
        buttons: {
            "OUI": function() {
                $( this ).dialog( "close" );
                ajouter();
                let msg="Et une ligne de plus...";
                $("#message").html(msg).css('color','green');
            },
            "NON": function() {
                $( this ).dialog( "close" );
                let msg="Dommage!! Cela sera pour une autre fois!!";
                $("#message").html(msg).css('color','red');
            }
        }
    });

}



/*######################################################################################*/
/* exercice 7 */
function timeout()
{
    ligne_selectionnee();
    let msg="La dernière ligne a été sélectionnée";
    $("#message").html(msg).css('color','green');
    setTimeout(function(){ $("#message").html(""); }, 3000);
}



