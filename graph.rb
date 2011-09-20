class Vertex
    attr_accessor :name
    def initialize(name)
        @name = name
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
        @edges.each { |edge| edges << edge if edge.in_vertex == vertex || edge.out_vertex == vertex }
        return edges
    end


    def get_neighbours(vertex)
        neighbours = Array.new
        @edges.each { |edge| neighbours << edge.out_vertex if edge.in_vertex == vertex || edge.out_vertex == vertex}
        return neighbours
    end

    # implementation of Dijkstra's algorithm for shortest path
    def dijkstra_shortest_path(start, finish)
        visited, unvisited = Array.new, Array.new
        distances = Hash.new

        distances[start] = 0
        unvisited << start

        # find the distance
        while not unvisited.empty?
            curr_node = unvisited.pop
            visited << curr_node
            get_edges(curr_node).each do |edge| 
                if visited.find_index(edge.out_vertex) == nil
                    unvisited.unshift(edge.out_vertex) if unvisited.find_index(edge.out_vertex) == nil
                    curr_distance, min_distance = distances[curr_node], distances[edge.out_vertex] || 1.0 / 0.0
                    if curr_distance + edge.distance < min_distance
                        distances[edge.out_vertex] = curr_distance + edge.distance
                    end
                end
            end
        end

        # figure out the path
        previous = finish
        path = Array.new() 
        path << previous
        while distances[previous] != 0
            get_edges(previous).each do |edge|
                if previous != edge.in_vertex && distances[edge.in_vertex] + edge.distance == distances[previous]
                    previous = edge.in_vertex
                    path << previous
                    break
                end
            end
        end
        
        return distances[finish], path.reverse
    end

    def bellman_ford_shortest_path(start, finish)
        predecessors, distances = Hash.new, Hash.new
        distances[start] = 0
        
        for i in (1..@vertices.size-1)
            @edges.each do |edge|
                u_dist = distances[edge.in_vertex] || 1.0/0.0
                v_dist = distances[edge.out_vertex] || 1.0/0.0
                if u_dist + edge.distance < v_dist
                    distances[edge.out_vertex] = u_dist + edge.distance
                    predecessors[edge.out_vertex] = edge.in_vertex
                end
            end
        end
        path = Array.new
        previous = finish
        path << previous
        while predecessors[previous] != nil
            previous = predecessors[previous]
            path << previous if previous != nil
        end

        return distances[finish], path.reverse
    end

    def prim_minimum_spanning_tree
        visited, mst = Array.new, Array.new
        visited << @vertices.first
        while visited.size != @vertices.size
            min_distance, min_edge = 1.0 / 0.0, nil
            visited.each do |u|
                get_edges(u).each do |edge|
                    if mst.find_index(edge) == nil && visited.find_index(edge.out_vertex) == nil && edge.in_vertex == u && edge.distance < min_distance
                        min_distance, min_edge = edge.distance, edge
                    end
                end
            end
            visited << min_edge.out_vertex
            mst << min_edge           
        end

        return mst
    end
end
