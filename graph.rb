class Vertex
    attr_accessor :name, :distance, :previous
    def initialize(name)
        @name = name
        @distance = 1.0/0.0
        @previous = nil
    end
    def to_s
        @name
    end
end

class Edge
    attr_accessor :in_vertex, :out_vertex, :distance
    def initialize(in_vertex, out_vertex, distance=1)
        @in_vertex, @out_vertex, @distance = in_vertex, out_vertex, distance
    end

    def to_s
        "(#{@in_vertex.to_s}, #{out_vertex.to_s}): #{distance}"
    end
end

class Graph
    attr_accessor :name, :vertices, :edges

    def initialize(name)
        @name = name
        @vertices = Array.new()
        @edges = Array.new()
    end

    def add_vertex(vertex)
        @vertices << vertex if @vertices.find_index(vertex) == nil
    end

    def add_edge(in_vertex, out_vertex, distance=1, bidirectional=true)
        add_vertex(in_vertex)
        add_vertex(out_vertex)
        @edges << Edge.new(in_vertex, out_vertex, distance)
        @edges << Edge.new(out_vertex, in_vertex, distance) if bidirectional
    end

    def get_edges(vertex)
        edges = Array.new
        @edges.each { |edge| edges << edge if edge.in_vertex == vertex }
        return edges
    end


    def get_neighbours(vertex)
        neighbours = Array.new
        @edges.each { |edge| neighbours << edge.out_vertex if edge.in_vertex == vertex }
        return neighbours
    end

    # implementation of Dijkstra's algorithm for shortest path
    def find_shortest_paths(start)
        visited, unvisited = Array.new, Array.new

        start.distance = 0
        unvisited << start

        while not unvisited.empty?
            curr_node = unvisited.pop
            visited << curr_node
            get_edges(curr_node).each do |edge| 
                if visited.find_index(edge.out_vertex) == nil
                    unvisited.unshift(edge.out_vertex) if unvisited.find_index(edge.out_vertex) == nil
                    if edge.out_vertex.previous == nil or curr_node.distance + edge.distance < edge.out_vertex.distance
                        edge.out_vertex.previous, edge.out_vertex.distance = curr_node, curr_node.distance + edge.distance
                    end
                end
            end
        end
    end

end

graph = Graph.new('myGraph')

# add vertices
a, b, c, d, e, f, g, h, i = Vertex.new('a'), Vertex.new('b'), Vertex.new('c'), Vertex.new('d'), Vertex.new('e'), Vertex.new('f'), Vertex.new('g'), Vertex.new('h'), Vertex.new('i')

# add edges
graph.add_edge(a, c, 9)
graph.add_edge(a, b, 2)
graph.add_edge(a, g, 4)
graph.add_edge(b, c, 4)
graph.add_edge(b, d, 2)
graph.add_edge(b, g, 6)
graph.add_edge(b, f, 7)
graph.add_edge(c, d, 3)
graph.add_edge(d, e, 5)
graph.add_edge(d, f, 3)
graph.add_edge(e, f, 3)
graph.add_edge(e, h, 4)
graph.add_edge(f, g, 5)
graph.add_edge(f, h, 4)
graph.add_edge(g, i, 2)
graph.add_edge(h, i, 3)

puts "Vertex count: #{graph.vertices.size()}"
puts "Edge count: #{graph.edges.size()}"

graph.find_shortest_paths(a)

# output
puts "shortest distance: #{e.distance}"
print "shortest path: "
prev = e
while prev != nil
  print "#{prev.to_s}, "
  prev = prev.previous
end
puts ""
