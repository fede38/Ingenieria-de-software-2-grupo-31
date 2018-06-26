
function addPeriodicField() {
	var date = new Date(); //esto es para los id

	//agarro los milisegundos desde la noche del primero de enero de 1970
	//y los uso para las key del map de Periodic
	var mSec = date.getTime();

	idAttributFecha =
		"trip_periodics_attributes_0_fecha".replace("0",mSec);
	nameAttributFecha = 
		"trip[periodics_attributes][0][fecha]".replace("0",mSec);

	idAttributHora =
		"trip_periodics_attributes_0_hora".replace("0",mSec);
	nameAttributHora = 
		"trip[periodics_attributes][0][hora]".replace("0",mSec);

	//creo la tag <li>
	var li = document.createElement("li");

	//create label for Fecha, set it's for attribute, 
    //and append it to <li> element
    var labelFecha = document.createElement("label");
    labelFecha.setAttribute("for", idAttributFecha);
    var fechaLabelText = document.createTextNode("Fecha");
    labelFecha.appendChild(fechaLabelText);
    li.appendChild(labelFecha);
 
    //create input for Fecha, set it's type, id and name attribute, 
    //and append it to <li> element
    var inputFecha = document.createElement("INPUT");
    inputFecha.setAttribute("type", "text");
    inputFecha.setAttribute("id", idAttributFecha);
    inputFecha.setAttribute("name", nameAttributFecha);
    li.appendChild(inputFecha);
 
    //create label for Hora, set it's for attribute, 
    //and append it to <li> element
    var labelHora = document.createElement("label");
    labelHora.setAttribute("for", idAttributHora);
    var horaLabelText = document.createTextNode("Hora");
    labelHora.appendChild(horaLabelText);
    li.appendChild(labelHora);
 
    //create input for Hora, set it's type, id and name attribute, 
    //and append it to <li> element
    var inputHora = document.createElement("INPUT");
    inputHora.setAttribute("type", "text");
    inputHora.setAttribute("id", idAttributHora);
    inputHora.setAttribute("name", nameAttributHora);
    li.appendChild(inputHora);
 
    //add created <li> element with its child elements 
    //(label and input) to myList (<ul>) element
    document.getElementById("myList").appendChild(li);
 
    //show multipleDates header
    $("#periodicHeader").show();

  


}