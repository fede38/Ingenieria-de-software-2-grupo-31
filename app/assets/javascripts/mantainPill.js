$('a[data-toggle="tab"]').on('show.bs.tab', function(e) {
    localStorage.setItem('activeTab', $(e.target).attr('href'));
});

// Acá guarda el index al cual corresponde la tab. Lo podés ver en el dev tool de chrome.
var activeTab = localStorage.getItem('activeTab');

// En la consola te va a mostrar la pestaña donde hiciste el último click y lo
// guarda en "activeTab". Te dejo el console para que lo veas. Y cuando refresques
// el browser, va a quedar activa la última donde hiciste el click.
console.log(activeTab);

if (activeTab) {
   $('a[href="' + activeTab + '"]').tab('show');
}