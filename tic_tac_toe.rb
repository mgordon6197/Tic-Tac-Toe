require 'pry'
class TicTacToe
  def initialize(dimension)
    @dimension = dimension
    raise('Dimension lower than 3 is not allowed') if dimension < 3
    @cell = []
    @available_moves = (1..@dimension**2).to_a
    @player_types = []
    @player_symbols = []
  end

  def valid_player?(player_type)
    %w(h c).include?(player_type)
  end

  def valid_symbol?(player_symbol)
    %w(X O).include?(player_symbol)
  end

  def draw_board
    1.upto(@dimension**2) do |index|
      print('|') if index % @dimension == 1
      print(@cell[index] || ' ')
      print('|')
      puts if (index % @dimension).zero?
    end
  end

  def winner_rows_condition
    out = []
    1.upto(@dimension) do |index|
      out << ((index - 1) * @dimension + 1..index * @dimension).to_a
    end
    out
  end

  def winner_columns_condition
    out = []
    1.upto(@dimension) do |index|
      out << index.step(@dimension**2, @dimension).to_a
    end
    out
  end

  def choose_player(number)
    p "Player #{number} Setup"
    loop do
      p 'Human or Computer(h/c)?'
      if valid_player?(player_type = gets.chomp)
        @player_types.unshift(player_type)
        break
      end
      puts 'We only allow humans or computers to play this game! Try again.'
    end
  end

  def choose_symbol
    loop do
      p 'X or O (X/O):'
      if valid_symbol?(player_symbol = gets.chomp)
        @player_symbols << player_symbol
        break
      end
      puts 'Select either X or O (case sensitive)'
    end
    @player_symbols.unshift(@player_symbols[0] == 'X' ? 'O' : 'X')
  end

  def winner_left_diagonal_condition
    [1.step(@dimension**2, @dimension + 1).to_a]
  end

  def winner_right_diagonal_condition
    [@dimension.step(@dimension**2 - 1, @dimension - 1).to_a]
  end

  def winner_conditions
    winner_columns_condition +
      winner_rows_condition +
      winner_left_diagonal_condition +
      winner_right_diagonal_condition
  end

  def winner?
    winner_conditions.any? do |condition|
      condition.all? { |index| @cell[index] == 'X' } ||
        condition.all? { |index| @cell[index] == 'O' }
    end
  end

  def play
    1.upto(@dimension**2) do |index|
      pick_index = make_move(index)
      @available_moves.delete(pick_index)
      @cell[pick_index] = @player_symbols[index % 2]
      print("\n\n")
      system('clear')
      sleep 1
      draw_board

      if winner?
        p "Player #{@players[index % 2]} WON!!!!"
        gets.chomp
        break
      elsif @available_moves.empty?
        p 'It\'s a tie!!'
        gets.chomp
        break
      end
    end
  end

  def setup_players
    choose_player(1)
    choose_symbol
    choose_player(2)
  end

  def make_move(turn)
    if @player_types[turn%2] == 'h'
      loop do
        p "#{@players[index % 2]} Enter Your move:"
        chosen_move = gets.chomp.
        if @available_moves.include?(chosen_move)
          return chosen_move
        end
        p 'Invalid move!'
      end
    else
      @available_moves.sample
    end
  end
end

size = 3
x = TicTacToe.new(size)
x.setup_players
x.play

