require "connect_four.rb"

describe 'Board' do

	let(:board) {Board.new}

	describe '.move' do
		it "should change the last item in a given column to a given character" do
			board.move(2,"X")
			expect(board.board_cells).to be == ([['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','_','_','_','_','_','_','_'],['_','X','_','_','_','_','_','_']])
		end
	end

	describe '.check_for_win' do
		it 'should check for a winner and return false' do
			expect(board.check_for_win('X')).to eql(false)
		end

		it 'should check for a winner and return true beacuse of horizontal win' do
			board.move(1,"X")
			board.move(2,"X")
			board.move(3,"X")
			board.move(4,"X")
			board.show
			expect(board.check_for_win('X')).to eql(true)
		end

		it "should check for a winner and return true because of vertical win" do
			board.move(1,"X")
			board.move(1,"X")
			board.move(1,"X")
			board.move(1,"X")
			board.show
			expect(board.check_for_win('X')).to eql(true)
		end

		it "should check for a winner and return true because of diagonal win" do
			board.move(1,"X")
			board.move(2,"0")
			board.move(2,"X")
			board.move(3,"0")
			board.move(3,"X")
			board.move(4,"0")
			board.move(3,"X")
			board.move(4,"0")
			board.move(4,"X")
			board.move(2,"0")
			board.move(4,"X")
			board.show
			expect(board.check_for_win('X')).to eql(true)
		end

	end

	describe '.valid_move?' do
		it "should return false because the move is invalid" do
			expect(board.valid_move?(0)).to eql(false)
		end

		it "should return true because the move is valid" do
			expect(board.valid_move?(5)).to eql(true)
		end
	end
end
