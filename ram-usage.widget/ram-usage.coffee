# ram.coffee
#
# Displays ram usage as bars and percentage
# Pink if higher than 87%
#
# Author: Aram Avila-Herrera
# Date: February 22, 2015
#
# License: Released under the GNU GPL v3 license (See ../LICENSE)

# These control the dimensions of the widget
width: 500
barHeight: 15
margin:
  right: 0
  left: 70

command: "memory_pressure | tail -n 1 | tr -d -C [[:digit:]]"
refreshFrequency: 2000

# Runs once
render: (output) ->
  """
  <svg class="ram-usage-chart"></svg>
  """

# Draw non-changing things
#afterRender: (domEl) ->

# Draw rectangular bar
update: (output, domEl) ->
  ram_usage = 100.0 - parseFloat(output)

  barHeight = @barHeight
  width = @width
  margin = @margin
  height = barHeight  # only showing one bar

  $.getScript 'd3js/d3.min.js.lib', ->

    # define the x-axis scale: x(data) maps data to x-axis
    x = d3.scale.linear()
      .domain [0, 100]
      .range [0, width - margin.left - margin.right]

    # define the y-axis scale: y(data) maps data to y-axis
    # d := list element, i := built-in counter
    y = d3.scale.ordinal()
        .domain ["ram:"]
        .rangeRoundBands [0, height], .1

    # define the y-axis
    yAxis = d3.svg.axis()
      .scale y
      .orient 'left'

    # set the chart dimensions
    chart = d3.select '.ram-usage-chart'
      .attr 'width', width + margin.left + margin.right
      .attr 'height', height

    # add y-axis to the chart here
    chart.select '.y.axis'
      .remove()
    chart.append 'g'
      .attr 'class', 'y axis'
      .attr 'transform', "translate(#{margin.left},0)"
      .call yAxis
    chart.select('.y.axis text')
      .attr 'dy', '.25em'
      .attr 'load', if ram_usage > 87 then 'high' else 'normal'

    # draw bars
    bar = chart.select '.bar.container'
      .remove()
    bar = chart.append 'g'
      .attr 'class', 'bar container'
      .attr 'transform', "translate(#{margin.left},#{y('ram:')})"
      .attr 'load', if ram_usage > 87 then 'high' else 'normal'
    bar
      .append 'rect'
      .attr 'class', 'bar obj'
      .attr 'width', x(ram_usage)
      .attr 'height', y.rangeBand()
    bar
      .append 'text'
      .attr 'class', 'bar txt'
      .attr 'x', x(ram_usage) + 2
      .attr 'y', y.rangeBand() / 2
      .attr 'dy', '.25em'
      .text "#{ram_usage}%"


# CSS in stylus
style: """
  opacity 0.3
  bottom 10%
  box-sizing border-box

  text
    font-family Courier
    font-size 15px

  .domain
    visibility hidden

  [load='normal']
    fill white
    opacity 0.25 !important
  [load='high']
    fill pink
    font-weight 900

"""
