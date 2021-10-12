Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  match 'movies/:id/directors', to: 'movies#directors', as: 'search_directors', via: [:get]
end
