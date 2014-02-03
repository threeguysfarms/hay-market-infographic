var HayMarketInfographic = (function() {
  var width = 960;
      height = 500;

  var aypByNameAndYear = d3.map(); 

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

  var formats = {
      currency: d3.format('$.2f')
  };

  var rdBuColors = colorbrewer.RdBu[10].reverse();

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
          var year = aypByNameAndYear.get(d.YEAR);
          if (!year) {
            year = aypByNameAndYear.set(d.YEAR, d3.map());
          }
          year.set(d.name, +d["price-per-ton"]);
        })
    .await(ready);

  function ready(error, us, ayp) {
    usMap = us;
    render(2012, usMap);
  } 

  function render(year, us) {
    var colors = d3.scale.linear()
      .domain(d3.extent(d3.values(aypByNameAndYear.get(year))))
      .range(["blue", "red"]);

    svg.selectAll(".state")
        .data(topojson.feature(us, us.objects.states).features)
        .enter().append("path")
        .attr("class", "states")
        .style("fill", function(d) { 
          return colors(aypByNameAndYear.get(year).get(d.id)); 
        })
        .attr("d", path);

    var legend = d3.select('#legend')
      .html('')
      .append('ul')
        .attr('class', 'list-inline');

    var keys = legend.selectAll('li.key')
        .data(colors.range());

    keys.enter().append('li')
        .attr('class', 'key')
        .style('border-top-color', String)
        .text(function(d) {
          if (d === "blue") { 
            return formats.currency(colors.domain()[0]);
          } else {
            return formats.currency(colors.domain()[1]);
          }
        });

  }
})();
