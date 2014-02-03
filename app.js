var HayMarketInfographic = (function() {
  var width = 960;
      height = 500;

  var aypByName = d3.map(); 

  var projection = d3.geo.albersUsa()
      .scale(1000)
      .translate([width / 2, height / 2]);

  var path = d3.geo.path()
      .projection(projection);

  var svg = d3.select(".container").append("svg")
      .attr("width", width)
      .attr("height", height);

  queue()
    .defer(d3.json, "us-states-by-state-name.json")
    .defer(d3.csv, 
      "acreage_yield_production_2012.csv", 
        function(d) { 
          aypByName.set(d.name, +d["price-per-ton"]);
        })
    .await(ready);

  function ready(error, us, ayp) {
    var quantize = d3.scale.linear()
      .domain(d3.extent(d3.values(aypByName)))
      .range(["blue", "red"]);

    svg.selectAll(".state")
        .data(topojson.feature(us, us.objects.states).features)
      .enter().append("path")
        .attr("class", "states")
        .style("fill", function(d) { 
          return quantize(aypByName.get(d.id)); 
        })
        .attr("d", path);
  }
})();
