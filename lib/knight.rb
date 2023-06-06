require 'json'

class Knight
  def initialize
    @graph = build_graph
  end

  def build_graph
    # builds graph with key for each square on board and values that correspond with moves you can make from that space
    graph = {}
    8.times do |x|
      8.times do |y|
        square = [x, y]
        graph[square] = []

        moves = possible_moves(square)

        moves.each do |move|
          destination_square = move
          graph[square] << destination_square unless graph[square].include?(destination_square)
        end
      end
    end

    graph
  end

  def possible_moves(square)
    # Gives a list of possible next moves from a position on an infinite board, can be called recursively to get future moves
    moves = []
    unless square.nil?
      moves << [square[0] + 1, square[1] + 2]
      moves << [square[0] + 2, square[1] + 1]
      moves << [square[0] + 1, square[1] - 2]
      moves << [square[0] + 2, square[1] - 1]
      moves << [square[0] - 1, square[1] - 2]
      moves << [square[0] - 2, square[1] - 1]
      moves << [square[0] - 1, square[1] + 2]
      moves << [square[0] - 2, square[1] + 1]
    end
    check_if_on_board(moves)
  end

  def check_if_on_board(moves)
    # checks if move is on board
    return if moves.nil?

    available_moves = []
    moves.each do |move|
      available_moves << move if move[0].between?(0, 7) && move[1].between?(0, 7)
    end
    available_moves
  end

  def find_path(start, goal)
    queue = []
    queue.push([start, [start]])

    until queue.empty?
      current, path = queue.shift

      print_path(path) if current == goal
      return path if current == goal

      @graph[current].each do |neighbor|
        queue.push([neighbor, path + [neighbor]]) unless path.include?(neighbor)
      end
    end

    nil  # No path exists
  end

  def print_path(path)
    puts "You made it in #{path.length} moves! Here's your path:"
    path.length.times do |i|
      p path[i]
    end
  end
end

graph = Knight.new

puts 'Start: [0,0]'
puts 'Target: [3,3]'
graph.find_path([0, 0], [3, 3])

puts "\nYour turn:"
puts 'Enter start in the following format [x,x], ex [0,0]. Max [7,7]'
start = JSON.parse(gets.chomp)
puts 'Enter target in the following format [x,x], ex [0,0]. Max [7,7]'
target = JSON.parse(gets.chomp)
graph.find_path(start, target)