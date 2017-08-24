class Board

	attr_accessor :board_cells

	def initialize
		@board_cells = generate_board
	end

	def generate_board
		row = []
		8.times do 
			row << '_'			
		end
		rows = []
		8.times do
			rows << row.clone
		end
		rows << [1, 2, 3, 4, 5, 6, 7, 8]
		rows
	end

	def show
		@board_cells.each do |row|
			row.each do |cell|
				print "#{cell} "
			end
			puts''
		end
		puts ''
	end


	def move(column, symbol)
		counter = -2
		until @board_cells[counter][column - 1] == '_'
			counter -= 1
		end
		@board_cells[counter][column - 1] = symbol
	end

	def valid_move?(column)
		if column > 8 or column < 1 or @board_cells[0][column - 1] != '_'
			return false
		end
		true
	end

	def check_for_win(symbol)
		return true if check_horizontal(symbol)
		return true if check_verticle(symbol)
		return true if check_diagonal(symbol)
		false
	end

	def check_horizontal(symbol)
		@board_cells.each do |row|
			count = 0
			row.each do |cell|
				if cell == symbol
					count += 1
					return true if count == 4
				else
					count = 0
				end
			end
		end
		false
	end

	def check_verticle(symbol)
		column_count = 0
		until column_count == 8
			row_count = 0
			count = 0
			until row_count == 8 do
				if @board_cells[row_count][column_count] == symbol
					count += 1
					return true if count == 4
				else
					count = 0
				end
				row_count +=1
			end
			column_count += 1
		end
		false
	end

	def check_diagonal(symbol)
		@board_cells.each_with_index do |row,row_num|
			row.each_with_index do |cell,column_num|
				check_row = row_num
				check_column = column_num
				if cell == symbol
					count = 1
					if row_num < 5 and column_num < 5
						until @board_cells[check_row + 1][check_column + 1] != symbol
							count +=1
							return true if count == 4
							check_row += 1
							check_column += 1
						end
					end
					count = 1
					if row_num < 5 and column_num > 2
						until @board_cells[check_row + 1][check_column - 1] != symbol
							count +=1
							return true if count == 4
							check_row += 1
							check_column -= 1
						end
					end
				end
			end
		end
		false
	end

end

class Ai

	def turn
		target = 1 + rand(8)
	end

end

class Game

	def initialize
		@board = Board.new
		@ai_on = false
		game_engine
	end

	def game_engine
		title
		ai_on_or_off
		clear_screen
		if @ai_on
			@ai = Ai.new
			ending = game_with_ai
		else
			ending = game_with_two_players
		end
		announce_winner(ending)
		end_of_game
	end

	def title
		puts "--------"
		puts "Connect Four!"
		puts "--------"
		puts ""
	end

	#clears the screen
	def clear_screen
		system "clear" or system "cls"
	end

	def error
		puts "*********************"
		puts "<ERROR> Invalid input"
		puts "*********************"
	end

	def ai_on_or_off
		puts "Enter '1' to play against the computer or '2' for 2 people!"
		input = gets.chomp.to_i
		if input == 1
			@ai_on = true
		elsif input == 2
			@ai_on = false
		else
			error
			ai_on_or_off			
		end
	end

	def who_goes_first
		puts "We need to decide who goes first! Pick 'heads' or 'tails'!"
		input = gets.chomp.downcase
		until input == "heads" || input == "tails"
			error
			puts "We need to decide who goes first! Pick 'heads' or 'tails'!"
			input = gets.chomp.downcase			
		end
		results = rand(2) + 1
		puts ''
		if results == 1 && input == "heads"
			puts "The result was 'heads'! You go first!"
			puts ''
			return "player"
		elsif results == 1 && input == "tails"
			puts "The result was 'heads'! The computer goes first!"
			puts ''
			return "ai"
		elsif results == 2 && input == "heads"
			puts "The result was 'tails'! The computer goes first!"
			puts ''
			return "ai"
		elsif results == 2 && input == "tails"
			puts "The result was 'tails'! You go first!"
			puts ''
			return "player"
		end
	end

	def game_with_ai
		turn = who_goes_first
		counter = 64
		until counter == 0
			if turn == "player"
				make_a_move("Player", "X")
				clear_screen
				break if @board.check_for_win("X")
				turn = "ai"
			elsif turn == "ai"
				input = @ai.turn
				until @board.valid_move?(input)
					input = @ai.turn
				end
				@board.move(input,"O")
				break if @board.check_for_win("O")
				turn = "player"
			end
			counter -= 1
		end
		if counter == 0
			return "draw"
		end
		turn
	end

	def game_with_two_players
		turn = "player 1"
		counter = 64
		until counter == 0
			if turn == "player 1"
				make_a_move("Player 1", "X")
				clear_screen
				break if @board.check_for_win("X")
				turn = "player 2"
			elsif turn == "player 2"
				make_a_move("Player 2", "0")
				clear_screen
				break if @board.check_for_win("0")
				turn = "player 1"
			end
			counter -= 1
		end
		if counter == 0
			return "draw"
		end
		turn
	end
	
	def make_a_move(player, symbol)
		@board.show
		puts "#{player}: Pick a column by entering the number of that column"
		input = gets.chomp.to_i
		until @board.valid_move?(input)
			error
			puts "#{player}: Pick a column by entering the number of that column"
			input = gets.chomp.to_i
		end
		@board.move(input, symbol)		
		@board.check_for_win(symbol)	
	end

	def announce_winner(ending)
		@board.show
		case ending
		when "player 1"
			puts "Player 1 is the winner!"
		when "player 2"
			puts "Player 2 is the winner!"
		when "ai"
			puts "The computer is the winner!"
		when "player"
			puts "You are the winner!"
		when "draw"
			puts "It's a draw! There aren't any valid moves left!"	
		end
	end

	def end_of_game
		puts ""
		puts "Would you like to play again? Press 'Y' to start a new game, or 'N' to quit."
		input = gets.chomp.upcase
		if input == 'Y'
			clear_screen
			game_engine
		elsif input == 'N'
			:exit
		else
			error
			end_of_game
		end
	end

end


game = Game.new




#board.move(3,"X")

#puts board.board_cells.to_s

#board.board_cells.each_with_index do |row,num|
#	puts "row: #{row}    num: #{num}"
#end