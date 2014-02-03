var HayMarketInfographic = (function() {
  var width = 960;
      height = 500;

  var aypByName = d3.map(); 

  var years = [];

  var usMap = {};

  var projection = d3.geo.albersUsa()
      .scale(1000)
      .translate([width / 2, height / 2]);

  var path = d3.geo.path()
      .projection(projection);

  var svg = d3.select(".container").append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("class", "center-block");

  queue()
    .defer(d3.json, "us-states-by-state-name.json")
    .defer(d3.csv, 
      "acreage_yield_production_93_13.csv", 
        function (d) { 
          if (years.indexOf(d.YEAR) == -1) {
            years.push(d.YEAR);
            $("#year-filter").append("<li><a href=\"#\" id=\"" + d.YEAR + "\">" + d.YEAR + "</a></li>");
            $("#year-filter a#" + d.YEAR).click(function() {
              $("span#selected_year").text($(this).attr("id"));
              render($(this).attr("id"), usMap);
            });
          }
          aypByName.set(d.YEAR+"~"+d.name, +d["price-per-ton"]);
        })
    .await(ready);

  function ready(error, us, ayp) {
    usMap = us;
    render(2012, usMap);
  } 

  function render(year, us) {
    var quantize = d3.scale.linear()
      .domain(d3.extent(d3.values(aypByName)))
      .range(["blue", "red"]);

    svg.selectAll(".state")
        .data(topojson.feature(us, us.objects.states).features)
      .enter().append("path")
        .attr("class", "states")
        .style("fill", function(d) { 
          return quantize(aypByName.get(year + "~" + d.id)); 
        })
        .attr("d", path);
  }
})();
