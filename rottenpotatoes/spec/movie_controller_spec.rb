require 'rails_helper'
require 'spec_helper'

# Running Rspec would pull up "ThreadError: already Initialized" which is caused by rails reusing ActionController::TestResponse
# Fix found on github.com/rails/rails/issues/34790 by user Vasfed
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController, :type => :controller do
	before(:all) do
		@Spielberg = Movie.create!(:director => "Steven Spielberg")
		@Hitchcock1 = Movie.create!(:director => "Alfred Hitchcock")
		@Hitchcock2 = Movie.create!(:director => "Alfred Hitchcock")
		@NoName = Movie.create!(:director => "")
	end
    describe "GET Index (Home page)" do
        it "Should render template" do
            get :index
            expect(response).to be_success
            expect(response).to render_template(:index)
            expect(response).to render_template("index")
        end
        it "Returns all movies in db" do
            get :index
            expect(response).to be_success
            expect(assigns[:movies]).to include(@Spielberg)
            expect(assigns[:movies]).to include(@Hitchcock1)
            expect(assigns[:movies]).to include(@Hitchcock2)
            expect(assigns[:movies]).to include(@NoName)
        end
    
    end

  describe "GET Show (Movie Details Page)" do
        it "Should render template" do
            get :show, :id => @Spielberg.id
            expect(response).to render_template(:show)
            expect(response).to render_template("show")
        end
        it "Shows selected movie information" do
            get :show, :id => @Spielberg.id
            expect(response).to be_success
            expect(assigns[:movie]).to eq(@Spielberg)
        end
  end

	describe "GET New (Create New Movie Page)" do
		it "Should render template" do
			get :new
			expect(response).to be_success
            expect(response).to render_template(:new)
			expect(response).to render_template("new")
		end
	end

	describe "GET Edit (Edit Existing Movie Page)" do
        it "Returns edit movie page for existing movie" do
            get :edit, :id => @Spielberg.id
            expect(response).to be_success
            expect(response).to render_template(:edit)
            expect(response).to render_template("edit")
        end

    end

	describe "PUT Update (Submit Edit Page)" do
        it "Should update movie information and return to movie detail page" do
            put :update, :id => @Spielberg.id, :movie=> { title: "E.T.", rating: "PG" }
            expect(assigns[:movie].title).to eq("E.T.")
            expect(assigns[:movie].rating).to eq("PG")
            expect(response).to redirect_to movie_path(@Spielberg)
        end
    end

	describe "GET directors (Find other movies by director)" do
		context "Given a movie has a director" do
			it "Returns all movies with same director" do
				get :directors, :id => @Hitchcock1.id
				expect(response).to render_template("directors")
			end
		end

		context "Given a movie has no director" do
			it "returns to index page" do
				get :directors, :id => @NoName.id
				expect(response).to redirect_to movies_path
			end
		end
	end
end