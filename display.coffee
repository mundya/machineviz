_chip_xy = (chip_spacing, machine_height, x, y) ->
  # Get the x and y co-ordinates to draw a chip at. This function is just a
  # translation of code written by Jonathan Heathcote.

  # Screen co-ordinates are from top to bottom, we want the other way round
  y = machine_height - y - 1

  # Add spacing between chips
  x *= 1.0 + chip_spacing
  y *= 1.0 + chip_spacing

  # Place on skewed co-ordinates
  x += y * Math.sin (Math.PI / 6.0)
  y *= Math.cos (Math.PI / 6.0)

  return [x, y]

draw_machine = (data) ->
  # Make the machine draggable
  machine = d3.select("svg#view g#machine")
  machine.translate_x = 0
  machine.translate_y = 0
  machine_drag = d3.behavior.drag()
  machine_drag.on("drag",
                  () ->
                    machine.translate_x += d3.event.dx
                    machine.translate_y += d3.event.dy
                    machine.attr("transform", "translate(" + machine.translate_x + ", " +
                                                             machine.translate_y + ")")
                  )
  d3.select("svg#view").call(machine_drag)

  # Create a new element for each chip
  d3.select("svg#view g#machine")
    .selectAll("g")
    .data(data.chips)
      .enter()
        .append("g")
        .attr("class", "chip")
        .attr("transform",
               (d) ->
                [x, y] = _chip_xy(80, data.height, d["x"], d["y"])
                return "translate(" + (x + data.width*50) + ", " + (y + 50) + ")"
              )
        .append("use")
        .attr("xlink:href", "#chip-path")

  # Add the cores
  d3.select("svg#view g#machine")
    .selectAll("g")
    .selectAll("circle")
    .data((d) -> [0...d.cores])
    .enter()
      .append("circle")
      .attr("class", "core")
      .attr("r", "3")
      .attr("cx", (d) -> (d % 5) * 8 - 16)
      .attr("cy", (d) -> Math.floor(d / 5) * 8 - 16)
