function processData(allRows) {
  var x = [], y = [], y2 = [], txt = [];

  for (var i=0; i<allRows.length; i++) {
    row = allRows[i];
    x.push( row['POS'] );
    y.push( row['GWAS.LOGP'] );
    y2.push( row['GWAS_cond.LOGP'] );
    txt.push( row['SNP'] );
  }
  makePlotly( x, y , y2 , txt );
}

function makePlotly( x, y , y2 , txt ){
	var frames = [
	{name: 'marg', data: [{x: x, y: y , ids: txt }]},
	{name: 'cond', data: [{x: x, y: y2, ids: txt }]}
	];
	Plotly.plot(
		'graph',
		[{
		  x: frames[0].data[0].x,
		  y: frames[0].data[0].y,
		  mode: 'markers',
		  text: frames[0].data[0].ids,
		  hoverinfo: 'text',
		  marker: {size:5 , color:"black" }
		}],
		{
		  updatemenus: [{
			buttons: [
			  {method: 'animate', args: [['marg']], label: 'Marginal'},
			  {method: 'animate', args: [['cond']], label: 'Conditional'}
			]
		  }],
		  height: 300,
		  margin: { l: 50, r: 50, b: 50, t: 0, pad: 4 },
		  xaxis: {title: "physical position"},
		  yaxis:{title:"-log10 P"},
		  hovermode:'closest'
		},
		{displayModeBar: false }
	).then( function() { Plotly.addFrames('graph', frames); } ).then(function(){Plotly.animate('graph', ['marg', 'cond'])});
}