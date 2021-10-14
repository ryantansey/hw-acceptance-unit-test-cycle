require 'rails_helper'

describe "Movie models directors tests" do
	before(:all) do
		@Spielberg = Movie.create!(:director => "Steven Spielberg")
		@Hitchcock1 = Movie.create!(:director => "Alfred Hitchcock")
		@NoName = Movie.create!(:director => "")
		@Hitchcock2 = Movie.create!(:director => "Alfred Hitchcock")
	end
	it 'should include other movies by same director' do
		 expect(Movie.find_same_director(@Hitchcock1[:director])).to include(@Hitchcock2)
		 expect(Movie.find_same_director(@Hitchcock2[:director])).to include(@Hitchcock1)
	end

	it 'should not include other movies with a different director' do
		 expect(Movie.find_same_director(@Hitchcock1[:director])).to_not include(@NoName)
		 expect(Movie.find_same_director(@Hitchcock2[:director])).to_not include(@Spielberg)
	end

	it 'should not include anything given a movie with empty director' do
		expect(Movie.find_same_director(@NoName[:director])).to_not include(@Hitchcock1)
		expect(Movie.find_same_director(@NoName[:director])).to_not include(@Spielberg)
		expect(Movie.find_same_director(@NoName[:director])).to_not include(@Hitchcock2)
	end
 end