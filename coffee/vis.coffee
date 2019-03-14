
class BubbleChart
  constructor: (data) ->
    @data = data
    @width = 1240
    @height = 600

    @tooltip = CustomTooltip("gates_tooltip", 240)

    # locations the nodes will move towards
    # depending on which view is currently being
    # used
    @center = {x: @width / 2, y: @height / 2}
    @year_centers = {
      "Economy": {x: @width/8*2-35, y: @height / 2},
      "Social Development": {x: @width/8*3-55, y: @height / 2},
      "Safety&Health": {x: @width/8*4-30, y: @height / 2}, 
      "Resources": {x:  @width/8*5-30, y: @height / 2},
      "Freedom": {x: @width/8*6.3-30, y: @height / 2}
    }
 
    # used when setting up force and
    # moving around nodes
    @layout_gravity = -0.01
    @damper = 0.1

    # these will be set in create_nodes and create_vis
    @vis = null
    @nodes = []
    @force = null
    @circles = null


    # nice looking colors - no reason to buck the trend
    @fill_color = d3.scale.ordinal()
      .domain(["positive", "negative"])
      .range(["#7aa25c","#a3a3c2"])

    # use the max total_amount in the data as the max in the scale's domain
    max_amount = d3.max(@data, (d) -> parseInt(d.magnitude))
    @radius_scale = d3.scale.pow().exponent(0.5).domain([5, max_amount]).range([5, 70])
    
    this.create_nodes()
    this.create_vis()

  # create node objects from original data
  # that will serve as the data behind each
  # bubble in the vis, then add each node
  # to @nodes to be used later
  create_nodes: () =>
    @data.forEach (d) =>
      node = {
        id: d.id
        radius: @radius_scale(parseInt(d.magnitude))
        value: d.correlation
        name: d.Feature
        category: d.Category
        sign: d.sign
        x: Math.random() * 900
        y: Math.random() * 800
        fx: 0
        fy: 1
      }
      @nodes.push node

    @nodes.sort (a,b) -> b.value - a.value


  # create svg at #vis and then 
  # create circle representation for each node
  create_vis: () =>
    @vis = d3.select("#vis").append("svg")
      .attr("width", @width)
      .attr("height", @height)
      .attr("id", "svg_vis")

    @circles = @vis.selectAll("circle")
      .data(@nodes, (d) -> d.id)

      
    # used because we need 'this' in the 
    # mouse callbacks
    that = this
    
    # @circles.enter().append("text")
    #   .attr("x", (d) -> d.x)
    #   .attr("y", (d) -> d.y)
    #   .attr("font-size","23px")
    #   .text((d) -> d.name)

    # radius will be set to 0 initially.
    # see transition below
    @circles.enter().append("circle")
      .attr("r", (d) => 0)
      .attr("fill", (d) => @fill_color(d.sign))
      .attr("stroke-width", 2)
      .attr("stroke", (d) => d3.rgb("#f0f0f5"))
      .attr("id", (d) -> "bubble_#{d.id}")
      .on("mouseover", (d,i) -> that.show_details(d,i,this))
      .on("mouseout", (d,i) -> that.hide_details(d,i,this))




    # Fancy transition to make bubbles appear, ending with the
    # correct radius
    @circles.transition().duration(2000).attr("r", (d) -> d.radius)

  

  charge: (d) ->
    -Math.pow(d.radius, 2.0) / 4.55

  # Starts up the force layout with
  # the default values
  start: () =>
    @force = d3.layout.force()
      .nodes(@nodes)
      .size([@width, @height])

  # Sets up force layout to display
  # all nodes in one circle.
  display_group_all: (d) =>
    @force.gravity(@layout_gravity)
      .charge(this.charge)
      .friction(0.9)
      .on "tick", (e) =>
        @circles.each(this.move_towards_center(e.alpha))
          .attr("cx", (d) -> d.x)
          .attr("cy", (d) -> d.y)


    
        this.hide_labels()
        this.hide_years()
        this.display_labels()
  #      this.display_legends()
  #      this.display_size()
    @force.start()





  # Moves all circles towards the @center
  # of the visualization
  move_towards_center: (alpha) =>
    (d) =>
      d.x = d.x + (@center.x - d.x) * (@damper + 0.02) * alpha
      d.y = d.y + (@center.y - d.y) * (@damper + 0.02) * alpha
      d.fx = d.x
      d.fy = d.y
  
  # sets the display of bubbles to be separated
  # into each year. Does this by calling move_towards_year
  display_by_year: () =>
    @force.gravity(@layout_gravity)
      .charge(this.charge)
      .friction(0.9)
      .on "tick", (e) =>
        @circles.each(this.move_towards_year(e.alpha))
          .attr("cx", (d) -> d.x)
          .attr("cy", (d) -> d.y)
    
    
        this.hide_labels()
        this.display_years()
        this.display_labels()
 #       this.display_legends()
    @force.start()
  
  # move all circles to their associated @year_centers 
  move_towards_year: (alpha) =>
    (d) =>
      target = @year_centers[d.category]
      d.x = d.x + (target.x - d.x) * (@damper + 0.02) * alpha * 1.1
      d.y = d.y + (target.y - d.y) * (@damper + 0.02) * alpha * 1.1
      d.fx = d.x
      d.fy = d.y

  # Method to display year titles
  display_years: () =>
    years_x = {"Economy": @width-1120, "Social Development": @width-900, "Safety&Health": @width-630 , "Resources": @width - 400, "Freedom": @width - 160 }
    years_data = d3.keys(years_x)
    categories = @vis.selectAll(".categories")
      .data(years_data)



    categories.enter().append("text")
      .attr("class", "categories")
      .attr("x", (d) => years_x[d] )
      .attr("y", 530)
      .attr("font-size","22px")
      .style("font-weight", "bold") 
      .attr("text-anchor", "middle")
      .text((d) -> d)


  display_labels:() => 

    @labels = @vis.selectAll(".name")
      .data(@nodes, (d) -> d.id)
    @labels.enter().append("text")
      .attr("id", (d) -> "label_#{d.id}")
      .attr("class","labels")
      .attr("x", (d) -> d.x)
      .attr("y", (d) -> d.y)
      .attr("font-size","12px")
      #.style("font-weight", "bold")  
      .attr("text-anchor", "middle")
      .attr("fill", "black")
      .text((d) -> d.name)

  # Method to hide year titiles
  hide_years: () =>
    categories = @vis.selectAll(".categories").remove()

  show_details: (data, i, element) =>
    d3.select(element).attr("stroke", "f0f0f5")
    content = "<span class=\"name\">Feature:</span><span class=\"value\"> #{data.name}</span><br/>"
    content +="<span class=\"name\">Correlation:</span><span class=\"value\"> #{addCommas(data.value)}</span><br/>"
    content +="<span class=\"name\">Category:</span><span class=\"value\"> #{data.category}</span>"
    @tooltip.showTooltip(content,d3.event)


  hide_details: (data, i, element) =>
    d3.select(element).attr("stroke", "#f0f0f5")
    @tooltip.hideTooltip()

  hide_labels: () =>
    labels = @vis.selectAll(".labels").remove()
  

 
  #display_legends: () =>
  #   @vis.append("text")
  #     .attr('x', 1000)
  #     .attr('y', 15)
  #     .style("font-size", "16px") 
  #     .text("Sign of Correlation");

#     @vis.append("circle")
#       .attr('cx', 900)
#       .attr('cy', 15)
#       .attr("r", 10)
#       .style("fill", "#7aa25c");

#     @vis.append("text")
#       .attr('x', 920)
#       .attr('y', 18)
#       .text("Positive Correlation");

#     @vis.append("circle")
#       .attr('cx', 1060)
#       .attr('cy', 15)
#       .attr("r", 10)
#       .style("fill", " #a3a3c2");

#     @vis.append("text")
#       .attr('x', 1080)
#       .attr('y', 18)
#       .text("Negative Correlation");

#  # display_size: () =>
#     @vis.append("circle")
#       .attr('cx', 1100)
#       .attr('cy', 100)
#       .attr("r", 70)
#       .style("fill", " #e0e0eb")
#       .attr("stroke-width", 1)
#       .attr("stroke", (d) => d3.rgb("#222222"));
    
#     @vis.append("text")
#       .attr('x', 1000)
#       .attr('y', 77)
#       .text("0.80")
#       .attr("font-size","16px");

#     @vis.append("circle")
#       .attr('cx', 1112)
#       .attr('cy', 115)
#       .attr("r", 52)
#       .style("fill", " #e0e0eb")
#       .attr("stroke-width", 1)
#       .attr("stroke", (d) => d3.rgb("#222222"));
    
#     @vis.append("text")
#       .attr('x', 1030)
#       .attr('y', 95)
#       .text("0.60")
#       .attr("font-size","16px");
    
#     @vis.append("circle")
#       .attr('cx', 1127)
#       .attr('cy', 126)
#       .attr("r", 32)
#       .style("fill", " #e0e0eb")
#       .attr("stroke-width", 1)
#       .attr("stroke", (d) => d3.rgb("#222222"));
    
        
#     @vis.append("text")
#       .attr('x', 1062)
#       .attr('y', 115)
#       .text("0.40")
#       .attr("font-size","16px");

#     @vis.append("circle")
#       .attr('cx', 1137)
#       .attr('cy', 136)
#       .attr("r", 17)
#       .style("fill", " #e0e0eb")
#       .attr("stroke-width", 1)
#       .attr("stroke", (d) => d3.rgb("#222222"));
    
#     @vis.append("text")
#       .attr('x', 1088)
#       .attr('y', 135)
#       .text("0.20")
#       .attr("font-size","16px");
    
#     @vis.append("text")
#       .attr('x', 900)
#       .attr('y', 45)
#       .text("Correlation Magnitude")
#       .attr("font-size","14px");


root = exports ? this

$ ->
  chart = null

  render_vis = (csv) ->
    chart = new BubbleChart csv
    chart.start()
    root.display_all()
  root.display_all = () =>
    chart.display_group_all()
  root.display_year = () =>
    chart.display_by_year()
  root.toggle_view = (view_type) =>
    if view_type == 'category'
      root.display_year()
    else
      root.display_all()

  d3.csv "data/data.csv", render_vis
