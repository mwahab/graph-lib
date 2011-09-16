require './graph'
require 'test/unit'

class GraphTest < Test::Unit::TestCase
    def setup
        @graph = Graph.new('myGraph')
        @a, @b, @c, @d, @e, @f, @g, @h, @i = Vertex.new('a'), Vertex.new('b'), Vertex.new('c'), Vertex.new('d'), Vertex.new('e'), Vertex.new('f'), Vertex.new('g'), Vertex.new('h'), Vertex.new('i')
        @graph.add_edge(@a, @c, 9)
        @graph.add_edge(@a, @b, 2)
        @graph.add_edge(@a, @g, 4)
        @graph.add_edge(@b, @c, 4)
        @graph.add_edge(@b, @d, 2)
        @graph.add_edge(@b, @g, 6)
        @graph.add_edge(@b, @f, 7)
        @graph.add_edge(@c, @d, 3)
        @graph.add_edge(@d, @e, 5)
        @graph.add_edge(@d, @f, 3)
        @graph.add_edge(@e, @f, 3)
        @graph.add_edge(@e, @h, 4)
        @graph.add_edge(@f, @g, 5)
        @graph.add_edge(@f, @h, 4)
        @graph.add_edge(@g, @i, 2)
        @graph.add_edge(@h, @i, 3)
    end

    def test_add_vertices
        assert_equal(@graph.vertices.size(),9)
    end

    def test_add_edges
        assert_equal(@graph.edges.size(), 32)
    end

    def test_shortest_path
        shortest_distance, path = @graph.dijkstra_shortest_path(@a, @e)
        assert_equal(shortest_distance, 9)
        path_s = ""
        path.each { |node| path_s = path_s + node.to_s }
        assert_equal(path_s, "abde")
    end
end
