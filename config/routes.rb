Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    post "/data-signals", to: "data_signals#generate_signal_data"
  end
end
